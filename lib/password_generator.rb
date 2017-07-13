module PasswordGenerator

  def generate_password(length=8)
    ('a'..'z').to_a.shuffle[0,length].join
  end

end
