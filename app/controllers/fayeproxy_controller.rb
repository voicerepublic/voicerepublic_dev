class FayeproxyController < ApplicationController

  def publish
    PrivatePub.publish_to(params[:channel], params[:data])
    render status: :ok
  end

end
