require 'vcr'
require 'webmock'

VCR.configure do |c|
  c.hook_into :webmock

  c.cassette_library_dir     = 'spec/support/vcr/cassettes'
  c.default_cassette_options = { preserve_exact_body_bytes: true }
  c.ignore_localhost         = false

  c.preserve_exact_body_bytes do |http_message|
    http_message.body.encoding.name == 'ASCII-8BIT' ||
    !http_message.body.valid_encoding?
  end

end
