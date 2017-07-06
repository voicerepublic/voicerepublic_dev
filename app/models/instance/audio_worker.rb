class Instance::AudioWorker < Instance

  def queue_endpoint
    Settings.endpoint.jobs
  end

  def runner_endpoint
    Settings.endpoint.runner
  end

  def aws_access_key
    Settings.fog.storage.aws_access_key_id
  end

  def aws_secret_key
    Settings.fog.storage.aws_secret_access_key
  end

end
