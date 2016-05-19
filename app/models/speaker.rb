class Speaker < ActiveRecord::Base
  validates :fullname, presence: true
  has_many :appearances, dependent: :destroy
end
