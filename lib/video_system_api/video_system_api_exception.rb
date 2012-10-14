module VideoSystemApi

  class VideoSystemApiException < Exception
    attr_accessor :key

    def to_s
      s = super.to_s
      s += ", messageKey: #{key.to_s}" unless key.nil? or key.to_s.empty?
      s
    end
  end

end
