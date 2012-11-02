module VideoSystemApi

  class VideoSystemParticipant
  
    attr_accessor :user_id, :full_name, :role
  
    def from_hash(hash)
      self.user_id = hash[:userID].to_s
      self.full_name = hash[:fullName].to_s
      self.role = hash[:role].to_s.downcase == "moderator" ? :host : :guest
    end
  
    def ==(other)
      r = true
      [:user_id, :full_name, :role].each do |param|
        r = r && self.send(param) == other.send(param)
      end
      r
    end
  
  end
end