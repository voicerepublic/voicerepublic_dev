# Slides intercepts incoming requests and returns a redirect.
#
class Slides < Struct.new(:app, :opts)

  PATTERN = %r{^/slides/(\d+)(.+)$} # e.g. /vrmedia/1-pj.m4a

  def call(env)
    return app.call(env) unless env['REQUEST_METHOD'] == 'GET'
    return app.call(env) unless md = env['PATH_INFO'].match(PATTERN)

    _, id, variant = md.to_a
    talk = Talk.find(id)
    location = talk.slides_url(perma=false)

    [ 302, { 'Location' => location }, [] ]
  end

end
