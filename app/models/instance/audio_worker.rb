class Instance::AudioWorker < Instance

  def default_client_token
    [ default_name, Time.now.to_i ] * '-'
  end

  def default_name
    [ 'aw', random_string ] * '-'
  end

  def random_string
    @random_string ||= generate_password(6)
  end

end
