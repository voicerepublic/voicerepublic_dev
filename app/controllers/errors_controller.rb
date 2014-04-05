# Handling exceptions dynamically using middleware.
# http://railscasts.com/episodes/53-handling-exceptions-revised?view=asciicast
class ErrorsController < ApplicationController
  def show
    @exception = env["action_dispatch.exception"]
    respond_to do |format|
      format.html { render action: request.path[1..-1] }
      # FIXME: json format does not yet render correctly
      format.json { render json: {status: request.path[1..-1], error: @exception.message}}
    end
  end
end
