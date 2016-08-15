class VenuesController < ApplicationController

  layout 'velvet'

  load_and_authorize_resource

  # redriects to venue if exactly one
  before_action :redirect_if_only_one, only: :index
  def redirect_if_only_one
    redirect_to(@venues.first) if @venues.size == 1
  end

  def show
    render layout: "velvet_minimal"
  end

  def update
    @venue.update_attributes(venue_params)

    redirect_to @venue
  end

  private

  def venue_params
    params.required(:venue).permit(:name,
                                   :emergency_phone_number,
                                   :street_address,
                                   :lat,
                                   :long,
                                   :estimated_number_of_listeners)
  end

end
