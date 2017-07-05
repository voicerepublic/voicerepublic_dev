class Job::Archive < Job

  def on_reset
    context.reset! if context.can_reset?
  end

  def on_start
    context.process!
  end

  def on_complete
    context.archive!
  end

end
