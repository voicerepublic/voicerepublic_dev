class VenuesController < ApplicationController

  ALLOWED_EVENTS = %w( become_available
                       start_provisioning
                       select_device )

  layout 'velvet_minimal'

  load_and_authorize_resource

  # redriects to venue if exactly one
  before_action :redirect_if_only_one, only: :index
  def redirect_if_only_one
    redirect_to(@venues.first) if @venues.size == 1
  end

  skip_before_action :verify_authenticity_token, only: [:update]

  # PUT /venues/:slug
  #
  # Responds to xhr requests. (Should hence problaby move to
  # `Xhr::VenuesController`.)
  #
  # Accepts and performs regular updates like setting...
  #
  #  * device_id
  #  * device_name
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

    # TODO move to model with `before_save :apply_event`
    if ALLOWED_EVENTS.include?(@venue.event)
      @venue.send(@venue.event)
    else
      logger.warn "Disallowed event: #{@venue.event}"
    end

    @venue.save!
    head :ok

  rescue => e
    render status: 409, text: e.message
  end


  def butt
    send_config 'butt'
  end

  def darkice
    send_config 'darkice'
  end

  private

  def send_config(client, extension=nil)
    send_data(@venue.send("#{client}_config"),
              filename: config_name(client, extension),
              type: 'text/plain')
  end

  def config_name(prefix, extension=nil)
    ([prefix, Time.now.strftime('%Y%m%d-%H%M'), @venue.slug] * '-') +
      extension || '.cfg'
  end

  def venue_params
    params.required(:venue).permit(:event,
                                   :device_id,
                                   :device_name,
                                   :emergency_phone_number,
                                   :street_address,
                                   :estimated_number_of_listeners)
  end

end
