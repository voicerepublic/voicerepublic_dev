class Section < ActiveRecord::Base

  TYPES = %w( string text )

  self.inheritance_column = :_type_disabled

  belongs_to :page

end
