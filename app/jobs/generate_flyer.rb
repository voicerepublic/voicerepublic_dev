class GenerateFlyer < MonitoredJob
  def perform
    Talk.find(opts[:id]).flyer.generate!
  end
end
