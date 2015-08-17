# Attributes:
# * id [integer, primary, not null] - primary key
# * created_at [datetime] - creation time
# * key [string] - TODO: document me
# * value [float] - TODO: document me
class Metric < ActiveRecord::Base

  module Figures

    # first let me sprinkle thee with some metaprogramming fairy dust
    extend self

    # Talks
    def talks_total
      @talks_total ||= Talk.count
    end

    def talks_featured_total
      Talk.where.not(featured_from: nil).count
    end

    def talks_featured_currently_total
      Talk.featured.count
    end

    def talks_prelive_total
      Talk.prelive.count
    end

    def talks_archived_total
      @talks_archived_total ||= Talk.archived.count
    end

    def talks_tagged_with_category_total
      @talks_tagged_with_category_total ||= ActsAsTaggableOn::Tagging
        .where('tag_id IN (?)', categories.pluck(:id))
        .where(taggable_type: 'Talk')
        .select(:taggable_id).distinct.count
    end

    def talks_tagged_with_category_percent
      100 / talks_total.to_f * talks_tagged_with_category_total
    end

    def talks_top_popularity
      Talk.maximum(:popularity)
    end

    def talks_top_penalty
      Talk.minimum(:penalty)
    end

    # Plays
    def plays_total
      @plays_total ||= Talk.archived.sum(:play_count)
    end

    def plays_per_talk_ratio
      plays_total / talks_archived_total.to_f
    end

    # User
    def users_total
      User.count
    end

    def new_users_total
      User.where("created_at > ?", 1.day.ago).count
    end

    def active_users_total
      User.where("last_sign_in_at > ?", 14.days.ago).count
    end

    def paying_users_total
      User.where(paying: true).count
    end

    def users_top_penalty
      Talk.minimum(:penalty)
    end

    # Series (aka. Venues)
    def series_total
      Venue.count
    end

    def series_nondefault_total # FIXME
      Venue.where('id NOT IN (?)', User.pluck(:default_venue_id)).count
    end

    def series_top_penalty
      Talk.minimum(:penalty)
    end

    # Tags, Taggings
    def tags_total
      @tags_total ||= ActsAsTaggableOn::Tag.count
    end

    def tags_categories_total
      @tags_categories_total = categories.count
    end

    def tags_categories_percent
      100 / tags_total.to_f * tags_categories_total
    end

    def taggings_total
      ActsAsTaggableOn::Tagging.count
    end

    # Appearances
    def appearances_total
      Appearance.count
    end

    # Messages (Chat)
    def messages_total
      @messages_total ||= Message.count
    end

    def messages_per_talk
      messages_total / talks_total.to_f
    end

    # Reminders
    def reminders_total
      Reminder.count
    end

    def reminders_users_total
      Reminder.select(:user_id).distinct.count
    end

    # SocialShares
    def socialshares_total
      SocialShare.count
    end

    def socialshares_facebook_total
      SocialShare.where(social_network: 'facebook').count
    end

    def socialshares_twitter_total
      SocialShare.where(social_network: 'twitter').count
    end

    def socialshares_email_total
      SocialShare.where(social_network: 'mail').count
    end

    # Metrics (yes, this is pretty meta)
    def metrics_figures_total
      Figures.public_instance_methods(false).size
    end

    def metrics_datapoints_total
      Metric.count
    end

    private

    def categories
      @categories ||= ActsAsTaggableOn::Tag.where(category: true)
    end

  end

  class << self
    def snapshot!
      Figures.public_instance_methods(false).map do |key|
        new(key: key, value: Figures.send(key)).tap(&:save)
      end
    end
  end

  # this is the format that nagios, munin, graphite, and others use
  def to_s
    [key.to_s.tr_s('_', '.'), value, created_at.to_i] * "\t"
  end

end
