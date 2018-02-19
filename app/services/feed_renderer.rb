# In developement you can run this services with
#
#     bundle exec bin/service run feed_renderer
#
# Then start a rails console and run
#
#     Emitter.render_feed(:talk, id: 1)
#
# Views & partials rendering RSS feeds
#
# - app/views/shared/_podcast.rss.builder  - common basis for all feeds
# - app/views/users/show.rss.builder       - user's feed of published talks (1)
# - app/views/reminders/index.rss.builder  - user's feed of pinned talks (2)
# - app/views/root/index.rss.builder       - featured talks of VR feed (3)
# - app/views/talks/show.rss.builder       - feed with a single talk (4)
# - app/views/series/show.rss.builder      - series' feed (5)

# the basics for services
require File.expand_path(File.join(%w[.. .. .. lib services]), __FILE__)

# booting rails
require File.expand_path(File.join(%w[.. .. .. config environment]), __FILE__)

# Logic:
# Talk.save -> Render Talk, TODO Series, TODO UsersPublished, TODO UsersPinned, TODO Featured
# Series.save -> Render TODO Series
# User.save -> Render TODO User
# TODO: translate titles for all feeds analogous to talks
# TODO: Write an integration test for all feeds with an exported
#       example from the old code and test it against the new code

# Service worker connected to RMQ handling rendering of RSS Podcast
# feeds
class FeedRenderer
  include Services::Subscriber
  include Services::Publisher

  subscribe x: 'render_feed_for_talk' # (1)
  subscribe x: 'render_feed_for_series' # (2)
  subscribe x: 'render_feed_for_users_published' # (3)
  subscribe x: 'render_feed_for_users_pinned' # (4)
  subscribe x: 'render_feed_for_featured' # (5)

  def initialize
    Rails.logger.info 'FeedRenderer Service started'
  end

  # Save open files so that they can be re-opened after daemonizing
  # the process (see `self.after_fork`). This implementation is copied
  # from Delayed Job:
  # https://github.com/collectiveidea/delayed_job/blob/ce88693429188a63793b16daaab67056a4e4e0bf/lib/delayed/worker.rb#L77
  def self.before_fork
    return if @files_to_reopen

    @files_to_reopen = []
    ObjectSpace.each_object(File) do |file|
      @files_to_reopen << file unless file.closed?
    end
  end

  def self.after_fork
    # Re-open file handles
    @files_to_reopen.each do |file|
      begin
        file.reopen file.path, 'a+'
        file.sync = true
      rescue ::Exception # rubocop:disable HandleExceptions, RescueException
      end
    end
  end

  # This will be triggered by, e.g.
  #
  #   Emitter.render_feed(:talk, id: 1)
  #
  def render_feed_for_talk(*args)
    opts = args.shift
    id = opts['id']
    Rails.logger.info "Received render_feed_for_talk with id #{id} (find me in #{__FILE__}:#{__LINE__})"

    Podcaster.new.render_for_talk(id)

    publish x: 'feed_rendered',
            any_further: 'details'
  end

  def render_feed_for_series(*args)
    opts = args.shift
    id = opts['id']

    Rails.logger.info "Received render_feed_for_series with id #{id} (find me in #{__FILE__}:#{__LINE__})"

    Podcaster.new.render_for_series(id)

    publish x: 'feed_rendered',
            any_further: 'details'
  end

  def render_feed_for_users_published(*args)
    opts = args.shift
    # TODO: render & store the feed
    publish x: 'feed_rendered',
            any_further: 'details'
  end

  def render_feed_for_users_pinned(*args)
    opts = args.shift
    # TODO: render & store the feed
    publish x: 'feed_rendered',
            any_further: 'details'
  end

  def render_feed_for_featured(*args)
    opts = args.shift
    # TODO: render & store the feed
    publish x: 'feed_rendered',
            any_further: 'details'
  end
end

# SERVICE FeedRenderer
# render_feed_for_talk ->
# render_feed_for_series ->
# render_feed_for_users_published ->
# render_feed_for_users_pinned ->
# render_feed_for_featured ->
# -> feed_rendered
