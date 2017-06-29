class Instance::AudioWorker < Instance

  def queue_endpoint
    Settings.job_queue_endpoint
  end

  def aws_credentials
    [ Settings.fog.storage.aws_access_key_id,
      Settings.fog.storage.aws_secret_access_key ] * ':'
  end

end
