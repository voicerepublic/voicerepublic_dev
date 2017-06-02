# core extensions

# fix the time class to provide a formatting option for ordinals
class Time
  alias_method :original_strftime, :strftime

  def strftime(fmt)
    original_strftime(fmt).gsub('%o', day.ordinal)
  rescue
    original_strftime(fmt)
  end
end

# module Kernel
#   def with_output_to(io)
#     raise 'no block?' unless block_given?
#     origerr, $stderr = $stderr, io
#     origout, $stdout = $stdout, io
#     yield
#     $stderr, $stdout = origerr, origout
#   end
# end

module FileUtils
  class << self
    def fileutils_output=(new_out)
      @fileutils_output = new_out
    end
  end
end
