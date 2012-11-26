class NoKluuu < Klu
  has_many :bookmarks, :dependent => :destroy, :foreign_key => :klu_id
  before_create :init
  
  def init
    self.published = true
  end
end
