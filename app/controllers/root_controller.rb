class RootController < BaseController

  layout 'velvet'

  def index
    respond_to do |format|
      format.html do
        @categories = TagBundle.promoted.category

        talks = Talk.publicly_live.limit(12)
        more = 12 - talks.count
        talks += Talk.promoted.limit(more) if more > 0
        @talks_listen_now = talks

        @talks_popular = Talk.popular.limit(12)
        @publishers = load_publishers
        @talks_upcoming = Talk.upcoming.limit(12)
      end
      format.rss do
        render file: Rails.root.join('public/feeds/featured/index.rss')
      end
      format.xml
    end
  end

  private

  def load_publishers
    path = Rails.root.join(*%w(config publishers.yml))
    YAML.load(File.read(path)).map do |pub|
      OpenStruct.new(pub)
    end
  end

end
