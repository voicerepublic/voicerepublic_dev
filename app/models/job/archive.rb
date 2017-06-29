class Archive < Job

  belongs_to :context, polymorphic: true

  def on_start
    context.process!
  end

  def on_complete
    context.archive!
  end

end
