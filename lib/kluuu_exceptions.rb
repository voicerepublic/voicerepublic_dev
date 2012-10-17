module KluuuExceptions
  
  class KluuuException < StandardError
    attr_reader :msg
    
    def initialize(msg)
        @msg = msg
    end
  end
  
  class KluuuExceptionWithRedirect < KluuuException
    attr_reader :redirect_link
    
    def initialize(msg, redirect_link)
        super(msg)
        @redirect_link = redirect_link
    end
  end
  
  class KluuuExceptionWithRender < KluuuException
    attr_reader :render_partial
    
    def initialize(msg, render_partial)
        super(msg)
        @render_partial = render_partial
    end
  end
  
  class PaymentError < KluuuException
  end
  
  class VideoServerRequired < KluuuException
  end
  
  class CallingUserError < KluuuException
  end
  
  class RatingError < KluuuException
  end
  
  class NoAccountError < KluuuExceptionWithRedirect
  end
  
  class NoFundsError < KluuuExceptionWithRedirect
  end
  
  class UserUnavailableError < KluuuExceptionWithRedirect
  end
  
  class KluUnavailableError < KluuuExceptionWithRender
  end
  
  class SameUserError < KluuuExceptionWithRender
  end
  
  class AnonymousUserError < KluuuExceptionWithRedirect
  end
end