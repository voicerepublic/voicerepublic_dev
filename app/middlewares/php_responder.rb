class PhpResponder < Struct.new(:app, :opts)

  RESPONSE = [721, {}, ['721 - PHP, see https://github.com/joho/7XX-rfc']]

  def call(env)
    return RESPONSE if env['PATH_INFO'].match(%r{\.php(\?|#|$)})
    app.call(env)
  end

end
