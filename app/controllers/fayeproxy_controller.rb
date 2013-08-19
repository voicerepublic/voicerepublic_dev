class FayeproxyController < ApplicationController

  def publish
    PrivatePub.publish_to(params[:channel], params[:data])
    render nothing: true, status: :ok
  end

end
