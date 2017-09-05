class Instance::Icebox < Instance

  belongs_to :context, polymorphic: true # context is a venue

  delegate :slug, :source_password, :admin_password, :icecast_callback_url, to: :context

  def on_complete
    context.complete_provisioning!
  end

  def recordings_path
    Settings.paths.recordings
  end

  # inherits ssh_keys from app server
  def ssh_keys
    path = File.expand_path('.ssh/authorized_keys', ENV['HOME'])
    return unless File.exist?(path)
    File.read(path)
  end

  def port
    Settings.icecast.url.port
  end

  def transcoding_script_url
  end

  def storage_url
    [ 's3:/', aws_bucket_name, slug, nil ] * '/'
  end

  def aws_access_key
    Settings.fog.storage.aws_access_key_id
  end

  def aws_secret_key
    Settings.fog.storage.aws_secret_access_key
  end

  def aws_region
    Settings.storage.recordings.split('@').last
  end

  # def default_client_token
  #   [ slug[0, 64-16], Time.now.to_i, generate_password(4) ] * '-'
  # end

  private

  def aws_bucket_name
    Settings.storage.recordings.split('@').first
  end


end
