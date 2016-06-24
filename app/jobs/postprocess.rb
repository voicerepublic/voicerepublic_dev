class Postprocess < MonitoredJob

  def perform
    Talk.find(opts[:id]).send(:postprocess!)
  end

end
