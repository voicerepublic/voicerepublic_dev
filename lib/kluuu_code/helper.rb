require 'socket'

module KluuuCode
  
  module Helper
    class IpAddress
      def IpAddress.local_ip
        if Socket.ip_address_list.detect{|intf| intf.ipv4? and !intf.ipv4_private? and !intf.ipv4_loopback? and !intf.ipv4_multicast?} && (Addrinfo.tcp(Socket.ip_address_list.detect{|intf| intf.ipv4? and !intf.ipv4_private? and !intf.ipv4_loopback? and !intf.ipv4_multicast?}.ip_address, 80).ip_address == Socket.getaddrinfo(Socket.gethostname,'http',nil,:STREAM)[0][2])
          return Socket.gethostname
        elsif Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
          return Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address
        else
          raise 'No callback IP or hostname detected'
        end
      end
    end
  end
end