Storage = Fog::Storage.new(Settings.fog.storage.to_hash)

Storage.directories.create key: 'vr-media'
# Storage.directories.create key: 'vr-import'
# Storagex.directories.create key: 'vr-test'
