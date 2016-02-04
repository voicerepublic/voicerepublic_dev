module Services
end

# this order is crucial
require File.expand_path(File.join(%w(.. services connector)), __FILE__)
require File.expand_path(File.join(%w(.. services local_config)), __FILE__)
require File.expand_path(File.join(%w(.. services publisher)), __FILE__)
require File.expand_path(File.join(%w(.. services subscriber)), __FILE__)
require File.expand_path(File.join(%w(.. services fog_ec2)), __FILE__)
require File.expand_path(File.join(%w(.. services auto_publish)), __FILE__)
