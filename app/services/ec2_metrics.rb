require File.expand_path(File.join(%w(.. .. .. lib services)), __FILE__)

class Ec2Metrics

  include Services::Publisher
  include Services::FogEc2

  DELAY = 60 * 60 # every hour

  def run
    loop do
      details = fog.servers.map { |s| s.attributes }
      publish exchange: 'cloud_metrics', details: details, type: 'ec2'
      sleep DELAY
    end
  end

end

# SERVICE Ec2Metrics
# => FogEc2
# -> cloud_metrics
