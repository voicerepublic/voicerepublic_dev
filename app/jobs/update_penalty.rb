class UpdatePenalty < MonitoredJob

  def perform
    talks = Talk.find(Array(opts[:id]))
    talks.each do |t|
      t.send(:set_popularity)
      t.save if t.popularity_changed?
    end
  end

end
