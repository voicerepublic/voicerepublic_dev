class VenuesController < ApplicationController

  layout 'velvet'

  load_and_authorize_resource

  before_action :redirect_if_only_one, only: :index

  def redirect_if_only_one
    redirect_to(@venues.first) if @venues.size == 1
  end

  def update
    @venue.start_provisioning!

    redirect_to @venue
  end

end
