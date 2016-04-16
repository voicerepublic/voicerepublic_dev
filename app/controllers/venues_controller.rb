class VenuesController < ApplicationController

  ALLOWED_EVENTS = [ :start_provisioning ]

  layout 'velvet'

  load_and_authorize_resource

  # redriects to venue if exactly one
  before_action :redirect_if_only_one, only: :index
  def redirect_if_only_one
    redirect_to(@venues.first) if @venues.size == 1
  end

  # PUT /venues/:slug
  #
  # Responds to xhr requests. (Should hence problaby move to
  # `Xhr::VenuesController`.)
  #
  # Accepts and performs regular updates like setting...
  #
  #  * device_id
  #
  # as well as optional information...
  #
  #  * emergency_phone_number
  #  * street_address
  #  * estimated_number_of_listeners
  #
  # Additionally takes a param `event` to issue on the given venue,
  # e.g. `start_provisioning`
  def update
    @venue.assign_attributes(venue_params)

    method = :save
    event = params[:event]
    method = event+'!' if ALLOWED_EVENTS.include?(event)

    @venue.send(method)
    head :ok

  rescue => e
    render status: 409, text: e.message
  end

  private

  def venue_params
    params.require(:venue).permit(:device_id,
                                  :emergency_phone_number,
                                  :street_address,
                                  :estimated_number_of_listeners)
  end

end
