class StorageFactory < Struct.new(:config)

  attr_accessor :clients

  def get(bucket_with_region, prefix=nil)
    unless bucket_with_region.include?('@')
      raise "Invalid bucket spec `#{value}` use `<bucket>@<region>` instead"
    end
    key, region = bucket_with_region.split('@')
    self.clients ||= {}
    self.clients[region] ||= Fog::Storage.new(config.merge(region: region))
    options = {}
    options[:prefix] = prefix unless prefix.nil?
    clients[region].directories.get(key, options) or
      # the fallback makes sure we do not need to have
      # the directories in place to make the specs pass
      clients[region].directories.new(key: key)
  end

end

Storage = StorageFactory.new(Settings.fog.storage.to_hash)

EC2 = Fog::Compute.new(Settings.fog.compute.to_hash)

# when using local storage provider, fake expiring urls with public
# urls
class Fog::Storage::Local::File
  def url(args)
    public_url
  end
end
