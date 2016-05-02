class ArchiveJob < MonitoredJob

  def perform
    Talk.find(opts[:id]).send(:archiv_from_dump!)
  end

end
