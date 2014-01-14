require 'socket'

module KluuuCode
  
  module Helper
    
    def Helper.local_ip
      
      if Rails.env ==  "test" || Rails.env == "development"
        return nil # ok for now
        return Socket.ip_address_list.detect { |intf| intf.ipv4_private? }.ip_address
      else
        return Socket.gethostname
      end
      
    end
    
    def Helper.local_port
      if Rails.env == "test" || Rails.env == "development"
        return "3000"
      else
        return "80"
      end
    end
    
    def Helper.centisize(amount)
      return (amount.to_f * 100).round
    end
  
    def Helper.dollarize(amount)
      return (amount.to_f / 100).round(2)
    end
    
  end
end
