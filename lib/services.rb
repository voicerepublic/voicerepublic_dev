module Services
end

# require first to resolve dependencies
require File.expand_path(File.join(%w(.. services connector)), __FILE__)

# require rest
pattern = File.expand_path(File.join(%w(.. services *.rb)), __FILE__)
Dir.glob(pattern).each { |f| require(f) }
