class Tts < Struct.new(:app, :opts)

  def call(env)
    return app.call(env) unless env['REQUEST_METHOD'] == 'GET'
    return app.call(env) unless env['PATH_INFO'] =~ %r{^/tts/(\d+)$}

    number = $1

    base = File.expand_path("../../../public/system/tts", __FILE__)
    FileUtils.mkdir_p(base) unless File.directory?(base)

    path = File.expand_path("#{number}.ogg", base)

    unless File.exist?(path)
      num = number.split(//).join(' ')
      text = "Pairing Code: #{num}."
      cmd = "echo '#{text}' | " +
            "text2wave - -eval '(voice_us1_mbrola)' | " +
            "oggenc - -o #{path}"
      system(cmd)
    end

    [ 302, {'Location' => "/system/tts/#{number}.ogg"}, [] ]
  end

end
