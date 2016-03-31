# MediaTracker intercepts incoming requests, tracks access and returns a
# redirect.
#
class MediaTracker < Struct.new(:app, :opts)

  PATTERN = /^\/vrmedia\/(\d+)(.+)$/ # e.g. /vrmedia/1-pj.m4a

  def call(env)
    return app.call(env) unless env['REQUEST_METHOD'] == 'GET'
    return app.call(env) unless md = env['PATH_INFO'].match(PATTERN)

    # TODO do some easy authorization based on variant

    _, id, variant = md.to_a

    talk = nil
    Talk.transaction do
      talk = Talk.find_by(id: id)
      talk.update_attribute(:play_count, talk.play_count + 1) unless talk.nil?
    end

    return [404, {}, []] if talk.nil?

    location = talk.generate_ephemeral_path! variant

    [ 302, { 'Location' => location }, [] ]
  end

end
