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
#
# USAGE
#
#    DebitTransaction.create(source: talk).process!
#
class DebitTransaction < Transaction

  delegate :user, to: :source

  def process!
    start!
    user.with_lock do
      user.credits -= 1
      user.save!
    end
    close!
  rescue Exception => e
    self.details ||= {}
    self.details[:error] = e
    abort!
  end
end
