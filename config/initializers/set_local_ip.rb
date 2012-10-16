require 'ip_getter'

Kluuu2::Application.config.ip_address = IpGetter::IpAddress.local_ip

