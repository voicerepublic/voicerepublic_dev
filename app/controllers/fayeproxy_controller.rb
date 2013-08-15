class FayeproxyController < ApplicationController

  def publish
    PrivatePub.publish_to(params[:channel], params[:data])
  end

end
