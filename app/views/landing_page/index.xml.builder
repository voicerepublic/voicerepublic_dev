namespaces = {
  'xmlns'       => "http://www.sitemaps.org/schemas/sitemap/0.9",
  'xmlns:image' => "http://www.google.com/schemas/sitemap-image/1.1"
}

# https://support.google.com/webmasters/answer/183668
total = Talk.count + Series.count + User.count
raise "Too many entries for sitemap." if total > 50_000

# http://www.w3.org/TR/NOTE-datetime
iso8601 = "%Y-%m-%dT%H:%M:%S%:z"

xml.instruct!
xml.urlset(namespaces.merge(total: total)) do |urlset|

  Talk.find_each do |talk|
    urlset.url do |url|
      # Do not use the url_for helper here, because it will be slow as hell!
      url.loc "https://" + request.host + "/talks/" + talk.slug
      url.image(:image) do |image|
        image.image(:loc, talk.image.url)
      end
      date = talk.processed_at || talk.updated_at
      url.lastmod date.strftime(iso8601)
      url.priority [talk.popularity.round(1), 0.1].max
    end
  end

  Series.joins(:talks).find_each do |series|
    urlset.url do |url|
      url.loc "https://" + request.host + "/series/" + series.slug
      url.image(:image) do |image|
        image.image(:loc, series.image.url)
      end
      processed_at = series.talks.pluck(:processed_at).compact.max
      date = processed_at || series.updated_at || series.created_at
      url.lastmod date.strftime(iso8601)
      popularity = series.talks.pluck(:popularity).max || 0
      url.priority [popularity.round(1), 0.1].max
    end
  end

  User.find_each do |user|
    urlset.url do |url|
      url.loc "https://" + request.host + "/users/" + user.slug
      url.image(:image) do |image|
        image.image(:loc, user.avatar.url)
      end
      date = user.updated_at || user.created_at
      url.lastmod date.strftime(iso8601)
    end
  end

end
