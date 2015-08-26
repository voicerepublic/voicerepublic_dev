# THIS SHOULD ONLY BE USED IN DEV ENV
#
# This is how rack conveys the posted form:
#
# "rack.request.form_hash"=>
#   {"key"=>"fe0efe52-137d-4809-a7c3-0f50fa3311de",
#    "file"=>
#      {:filename=>"09 - Back Again.mp3",
#       :type=>"audio/mp3",
#       :name=>"file",
#       :tempfile=>#<File:/tmp/RackMultipart20150825-15366-inb9l6.mp3>,
#         :head=>
#           "Content-Disposition: form-data; name=\"file\"; filename=\"09 - Back Again.mp3\"\r\nContent-Type: audio/mp3\r\n"}},
#
class CloudUpload < Struct.new(:app, :opts)

  PREFIX = %w(..) * 3

  def call(env)
    return app.call(env) unless env['REQUEST_METHOD'] == 'PUT'
    md = env['PATH_INFO'].match(regex)
    return app.call(env) if md.nil?

    #pp opts
    #pp md
    #pp Dir.pwd
    #pp env['rack.input']
    #pp env

    form = env['rack.request.form_hash']
    source = form['file'][:tempfile].path
    name = form['key']
    bucket = md.to_a[1]

    target = File.join(PREFIX, opts[:fs_path], bucket, name)
    target = File.expand_path(target, __FILE__)

    FileUtils.cp source, target, verbose: true

    [ 200, {}, [] ]
  end

  private

  def regex
    @regex ||= opts[:url_path] + '/(.*)$'
  end

end
