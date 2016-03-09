class ProcessOverride < MonitoredJob

  def perform
    Talk.find(opts[:id]).send(:process_override!)
  end

end
