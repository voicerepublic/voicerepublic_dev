class Reprocess < MonitoredJob

  def perform
    Talk.find(opts[:id]).send(:reprocess!)
  end

  def before_message(job)
    @t0 = Time.now
    "start reprocessing talk #{opts[:id]}"
  end

  def success_message(job)
    delta = Time.now - @t0
    min, sec = delta / 60, delta % 60
    delta = "%02d:%02d" % [min, sec]
    "succeeded reprocessing talk #{opts[:id]} (#{delta})"
  end

  def error_message(job, exception)
    delta = Time.now - @t0
    min, sec = delta / 60, delta % 60
    delta = "%02d:%02d" % [min, sec]
    "error while reprocessing talk #{opts[:id]}: #{exception.message} (#{delta})"
  end

end
