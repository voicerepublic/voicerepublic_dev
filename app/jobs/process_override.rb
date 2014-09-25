class ProcessOverride < MonitoredJob

  def perform
    Talk.find(opts[:id]).send(:process_override!)
  end

  def before_message(job)
    @t0 = Time.now
    "start overriding talk #{opts[:id]}"
  end

  def success_message(job)
    delta = Time.now - @t0
    min, sec = delta / 60, delta % 60
    delta = "%02d:%02d" % [min, sec]
    "succeeded overriding talk #{opts[:id]} (#{delta})"
  end

  def error_message(job, exception)
    delta = Time.now - @t0
    min, sec = delta / 60, delta % 60
    delta = "%02d:%02d" % [min, sec]
    "error while overriding talk #{opts[:id]}: #{exception.message} (#{delta})"
  end

end
