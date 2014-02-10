# core extensions

# fix the time class to provide a formatting option for ordinals
class Time
  alias_method :original_strftime, :strftime
  def strftime(fmt)
    original_strftime(fmt).gsub('%o', day.ordinal)
  end
end
