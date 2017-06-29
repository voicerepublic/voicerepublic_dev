class ArchiveJob < Struct.new(:opts)

  def perform
    # this will be performed remotely
  end

end
