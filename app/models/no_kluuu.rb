# Attributes:
# * id [integer, primary, not null] - primary key
# * available_at_times [string] - TODO: document me
# * category_id [integer] - belongs to :category
# * charge_cents [integer, default=0] - TODO: document me
# * charge_type [string, default="free"] - TODO: document me
# * created_at [datetime, not null] - creation time
# * currency [string] - TODO: document me
# * description [text] - TODO: document me
# * published [boolean] - TODO: document me
# * title [string]
# * type [string] - TODO: document me
# * updated_at [datetime, not null] - last update time
# * user_id [integer] - belongs to :user
class NoKluuu < Klu
  has_many :bookmarks, :dependent => :destroy, :foreign_key => :klu_id
end
