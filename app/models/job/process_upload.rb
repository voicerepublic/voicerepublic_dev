class Job::ProcessUpload < Job

  def on_reset
    return if context.nil?
    context.reset! if context.can_reset?
  end

  def on_complete
    context.archive!
  end

end
