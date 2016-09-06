class Xhr::VenuesController < Xhr::BaseController

  ALLOWED_EVENTS = %w( become_available
                       start_provisioning
                       select_device )

  load_and_authorize_resource

  skip_before_action :verify_authenticity_token, only: [:update]

  # PUT /xhr/venues/:slug
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

    # this is one of those highlander situations
    @venue.device = nil if venue_params[:device_name]
    @venue.device_name = nil if venue_params[:device_id]

    # HACK!, FIXME fix the domain model so this is not needed
    if @venue.device.present?
      Venue.where(device_id: @venue.device_id).
        where.not(id: @venue.id).update_all(device_id: nil)
    end

    # TODO move to model with `before_save :apply_event`
    if ALLOWED_EVENTS.include?(@venue.event)
      @venue.send(@venue.event)
    else
      logger.warn "Disallowed event: #{@venue.event}"
    end

    @venue.save!
    head :ok

  rescue => e
    render status: 409, text: e.message + "\n" + e.backtrace * "\n"
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
      (extension || '.cfg')
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
