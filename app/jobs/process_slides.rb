class ProcessSlides < MonitoredJob

  def perform
    Talk.find(opts[:id]).send(:process_slides!)
  end

end
