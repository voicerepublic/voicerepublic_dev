class ErrorsController < ApplicationController

  skip_before_filter :check_browser

  # Handling exceptions dynamically using middleware.
  # http://railscasts.com/episodes/53-handling-exceptions-revised?view=asciicast
  def show
    @exception = env["action_dispatch.exception"]
    status = request.path[1..-1]
    respond_to do |format|
      format.html { render action: status, status: status }
      # FIXME: json format does not yet render correctly
      format.json { render json: { status: status, error: @exception.message } }
    end
  end

  # Dedicated landing page for outdated browsers
  def upgrade_browser
  end

end
