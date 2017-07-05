class Job::Archive < Job

  def on_start
    context.process!
  end

  def on_complete
    context.archive!
  end

end
