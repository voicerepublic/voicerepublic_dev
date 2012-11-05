require 'socket'

module KluuuCode
  
  module Helper
    class IpAddress
      def IpAddress.local_ip
        if Rails.env == 'production'
          return Socket.gethostname
        elsif Rails.env == 'test' || 'development'
          tmp = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address + ':3000'
          return tmp
        else
          raise 'No callback IP or hostname detected'
        end
      end
    end
  end
end