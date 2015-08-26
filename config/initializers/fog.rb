Storage = Fog::Storage.new(Settings.fog.storage.to_hash)

#puts "[DBG] Creating buckets..."
#
#Storage.directories.create key: Settings.storage.media
#Storage.directories.create key: Settings.storage.import
#Storage.directories.create key: Settings.storage.upload_audio, acl: 'public-read-write'
#Storage.directories.create key: Settings.storage.upload_slides, acl: 'public-read-write'
#
#puts "[DBG] Creating buckets complete."

# when using local storage provider, fake expiring urls with public
# urls
class Fog::Storage::Local::File
  def url(args)
    public_url
  end
end

# guerilla patch local storage to provide endpoints for simulating
# upload to cloud storage locally
class Fog::Storage::Local::Real
  def put_object_url(*args)
    (endpoint + '/' + args.first) + '?a=b&c=d'
  end

  def get_object_url(*args)
    [endpoint, *args] * '/'
  end
end
