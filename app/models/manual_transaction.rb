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
    Simon.comprehend(self)
  rescue Exception => e
    self.details ||= {}
    self.details[:error] = e
    abort!
  end

end
