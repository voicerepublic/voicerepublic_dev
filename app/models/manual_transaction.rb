# Attributes:
# * id [integer, primary, not null] - primary key
# * created_at [datetime] - creation time
# * details [text] - TODO: document me
# * failed_at [datetime] - TODO: document me
# * processed_at [datetime] - TODO: document me
# * source_id [integer] - belongs to :source (polymorphic)
# * source_type [string] - belongs to :source (polymorphic)
# * state [string] - TODO: document me
# * type [string] - TODO: document me
# * updated_at [datetime] - last update time
class ManualTransaction < Transaction

  def process!
    start!
    user = User.find(details[:user_id])
    user.with_lock do
      user.credits += details[:quantity].to_i
      user.paying = true if details[:payment].to_i > 0
      user.save!
    end
    close!
    tell_simon
  rescue Exception => e
    self.details ||= {}
    self.details[:error] = e
    abort!
  end


  def tell_simon
    quantity = details[:quantity].to_i
    payment = details[:payment].to_i
    admin = AdminUser.find(source_id).email
    name = User.find(details[:user_id]).name
    msg = nil

    # deduct credits
    if quantity < 0 && payment == 0
      msg = "Admin #{admin} deducted #{quantity} credits from #{name}."
    end
    # undo booking
    if quantity < 0 && payment < 0
      msg = "Admin #{admin} undid a booking for #{name}, " +
            "by deducting #{quantity} credits and giving EUR #{payment} back."
    end
    # donate
    if quantity > 0 && payment == 0
      msg = "Admin #{admin} donated #{quantity} credits to #{name}."
    end
    # sale
    if quantity > 0 && payment > 0
      msg = "Admin #{admin} sold #{quantity} credits for EUR #{payment} to #{name}."
    end
    # track previous sale
    if quantity == 0 && payment > 0
      msg = "Admin #{admin} tracked a sale for EUR #{payment} " +
            "to #{name}, retrospectively."
    end

    # noop
    if quantity == 0 && payment == 0
      msg = "Admin #{admin} contemplated about the meaning of life."
    end
    # weird stuff going on
    if (quantity < 0 && payment > 0) ||
       (quantity >= 0 && payment < 0)
      msg = "Admin #{admin} and #{name} seem to be in cahoots. " +
            "Alert the authorities, fishy transaction going on."
    end

    raise 'Unknown manual transaction case!' if msg.nil?
    Simon.says(msg)
  end

end
