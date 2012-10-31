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
    attr_reader :locals
    
    def initialize(msg, render_partial, locals = nil)
        super(msg)
        @render_partial = render_partial
        locals ||=  {}
        @locals = locals 
        @locals[:msg] = msg
    end
  end
  
  class PaymentError < KluuuException
  end
  
  class VideoSystemError < KluuuExceptionWithRender
  end
  
  class CallingUserError < KluuuExceptionWithRender
  end
  
  class RatingError < KluuuException
  end
  
  class NoAccountError < KluuuExceptionWithRender
  end
  
  class NoFundsError < KluuuExceptionWithRender
  end
  
  class UserUnavailableError < KluuuExceptionWithRender
  end
  
  class KluUnavailableError < KluuuExceptionWithRender
  end
  
  class SameUserError < KluuuExceptionWithRender
  end
  
  class AnonymousUserError < KluuuExceptionWithRender
  end
end