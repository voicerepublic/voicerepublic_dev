module VideoSystemApi

  # Helper class to format the response hash received when the BigBlueButtonApi makes API calls
  class VideoSystemApiFormatter
    attr_accessor :hash

    def initialize(hash)
      @hash = hash
    end

    # converts a value in the @hash to boolean
    def to_boolean(key)
      @hash[key] = @hash[key].downcase == "true"
    end

    # converts a value in the @hash to string
    def to_string(key)
      @hash[key] = @hash[key].to_s
    end

    # converts a value in the @hash to DateTime
    def to_datetime(key)
      @hash[key] = @hash[key] == "NULL" ? nil : Time.at(@hash[key])
    end

    # Default formatting for all responses given by a BBB server
    def default_formatting

      # remove the "response" node
      response = Hash[@hash[:response]].inject({}){|h,(k,v)| h[k] = v; h}

      # Adjust some values. There will always be a returncode, a message and a messageKey in the hash.
      response[:returncode] = response[:returncode].downcase == "success"                              # true instead of "SUCCESS"
      response[:messageKey] = "" if !response.has_key?(:messageKey) or response[:messageKey].empty?    # "" instead of {}
      response[:message] = "" if !response.has_key?(:message) or response[:message].empty?             # "" instead of {}

      @hash = response
    end

    # default formatting for a meeting hash
    def format_meeting(meeting)
      meeting[:meetingID] = meeting[:meetingID].to_s
      meeting[:moderatorPW] = meeting[:moderatorPW].to_s
      meeting[:attendeePW] = meeting[:attendeePW].to_s
      meeting[:hasBeenForciblyEnded] = meeting[:hasBeenForciblyEnded].downcase == "true"
      meeting[:running] = meeting[:running].downcase == "true"
      meeting
    end

    # default formatting for an attendee hash
    def format_attendee(attendee)
      attendee[:userID] = attendee[:userID].to_s
      attendee[:role] = attendee[:role].downcase.to_sym
      attendee
    end

    # simplifies the hash making a node e.g. :attendee with an array with all attendees
    # TODO: comments with the expected @hash at this point
    def flatten_objects(first, second)
      if @hash[first].empty?
        collection = []
      else
        node = @hash[first][second]
        if node.kind_of?(Array)
          collection = node
        else
          collection = []
          collection << node
        end
      end
      @hash[first] = collection
      @hash
    end

  end
end
