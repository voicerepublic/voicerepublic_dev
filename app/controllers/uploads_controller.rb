class UploadsController < ApplicationController

  def new
    attrs = params[:talk] ? talk_params : {}
    attrs[:venue_id] ||= current_user.default_venue_id
    @talk = Talk.new(attrs)
  end

  def create
  end
end
