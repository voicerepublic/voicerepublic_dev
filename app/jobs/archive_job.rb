class ArchiveJob < MonitoredJob

  def perform
    Talk.find(opts[:id]).send(:archive_from_dump!)
  end

end
