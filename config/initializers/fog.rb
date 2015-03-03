Storage = Fog::Storage.new(Settings.fog.storage.to_hash)

Storage.directories.create key: Settings.storage.media
Storage.directories.create key: Settings.storage.import
Storage.directories.create key: Settings.storage.uploads, acl: 'public-read-write'

# when using local storage provider, fake expiring urls with public
# urls
class Fog::Storage::Local::File
  def url(args)
    public_url
  end
end
