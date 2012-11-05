require 'socket'

module KluuuCode
  
  module Helper
    
    def Helper.local_ip
      
      #if Rails.env ==  "test" || "development"
      #  return Socket.ip_address_list.detect { |intf| intf.ipv4_private? }.ip_address
      #else
        return Socket.gethostname
      #end
      
    end
    
    def Helper.local_port
      #if Rails.env == "test" || "development"
      #  return "3000"
      #else
        return "80"
      #end
    end
    
  end
  
end