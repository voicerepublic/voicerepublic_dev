module KluuuCode

  module Methods
    
    def prefs
      if read_attribute(:prefs).nil?
        write_attribute :prefs, Kluuu::Preferences.new
        read_attribute :prefs
      else
        read_attribute :prefs
      end
    end

    def prefs=(val)
      self.prefs.set_attributes(val)
      if val.instance_of?(KluuuCode::Preferences)
        write_attribute :prefs, val
      else
        _p = KluuuCode::Preferences.new
        _p.set_attributes(val)
      end
    end
    
  end
  
  
  class Preferences 
    attr_accessor :email_concerning_me, :email_concerning_other
    attr_accessor :inform_of_friends
    attr_accessor :no_initial_help
    attr_accessor :anonymous_calls
    
    def initialize(args=nil)
      @anonymous_calls, @email_concerning_me,  @email_concerning_other, @inform_of_friends, @no_initial_help = 0, 1, 1, 1, 1
      unless args.nil?
        self.update_attributes(args)
      end
      self
    end
    
    def update_attributes(hash)
      hash.each_pair do |k,v|
        
        if self.respond_to?(k) 
          self.send("#{k}=", v )
        else 
          Rails.logger.warn("KluuuCode::Preferences#update_attributes - writing non-existent attr: #{k}")#
          self.send("#{k}=", v)
          #raise NoMethodError.new("undefined attribut '#{k}' for Preferences")
        end
      end
    end
    
    def set_attributes(hash)
      update_attributes(hash)
    end
    
    #def method_missing
      
    #end
    
  end

end