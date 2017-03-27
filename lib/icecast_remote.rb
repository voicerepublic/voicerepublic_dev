require 'faraday'

class IcecastRemote < Struct.new(:options)

  def disconnect!
    faraday.basic_auth('admin', options[:admin_password])
    faraday.get(url)
  end

  private

  def url
    'http://%s:%s/admin/killsource.xsl?mount=/%s' %
      [options[:public_ip_address],
       options[:port],
       options[:mount_point]]
  end

  def faraday
    @faraday ||= Faraday.new(url: url) do |f|
      f.request :url_encoded
      f.adapter Faraday.default_adapter
    end

  end

end
