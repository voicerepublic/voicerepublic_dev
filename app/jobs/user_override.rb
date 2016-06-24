class UserOverride < MonitoredJob

  def perform
    Talk.find(opts[:id]).send(:user_override!)
  end

end
