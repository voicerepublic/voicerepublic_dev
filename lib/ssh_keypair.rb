module SshKeypair

  extend self

  def generate
    base = Dir.mktmpdir('keys')
    keypath = File.expand_path('id_rsa', base)
    %x[ssh-keygen -t rsa -N "" -f #{keypath}]
    private_key = File.read(keypath)
    public_key = File.read(keypath + '.pub')
    FileUtils.remove_entry(base)
    [private_key, public_key]
  end

end
