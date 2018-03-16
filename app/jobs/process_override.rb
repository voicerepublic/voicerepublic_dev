class ProcessOverride < MonitoredJob

  def perform
    Talk.find(opts[:id]).send(:schedule_override)
  end

end
