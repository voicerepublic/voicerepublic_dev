class Reprocess < MonitoredJob

  def perform
    Talk.find(opts[:id]).send(:reprocess!)
  end

end
