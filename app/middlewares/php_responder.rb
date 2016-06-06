class PhpResponder < Struct.new(:app, :opts)

  RESPONSE = [721, {}, ['721 - PHP, see https://github.com/joho/7XX-rfc']]

  def call(env)
    return RESPONSE if env['PATH_INFO'].match(%{\.php(\?|#|$)})
    app.call(env)
  end

end
