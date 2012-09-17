class NoKluuu < Klu
  has_many :bookmarks, :dependent => :destroy, :foreign_key => :klu_id
  
  
end
