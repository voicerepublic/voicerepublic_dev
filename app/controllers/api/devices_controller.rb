class Api::DevicesController < ApplicationController

  respond_to :json

  skip_before_action :verify_authenticity_token

  TARGETS = Settings.devices.endpoint.to_hash.keys


  # Streamboxx: Knocking
  # GET /api/devices/:id
  def show
    @device = Device.find_by(identifier: params[:id])

    target = @device.try(:target) || 'live' # fallback to live
    raise "Unknown target: #{target}" unless TARGETS.include?(target.to_sym)

    endpoint = @device.opts.endpoint if @device
    endpoint ||= Settings.devices.endpoint[target]

    loglevel = @device.try(:loglevel) || Logger::INFO

    branch = @device.try(:source_branch)

    render json: { endpoint: endpoint, loglevel: loglevel, branch: branch }
  end


  # Streamboxx: Registering
  # POST /api/devices
  def create
    @device = Device.find_or_initialize_by(device_params)

    @device.public_ip_address    = request.remote_ip
    @device.subtype              = params[:device][:subtype]
    @device.private_ip_address   = params[:device][:private_ip_address]
    @device.mac_address_ethernet = params[:device][:mac_address_ethernet]
    @device.mac_address_wifi     = params[:device][:mac_address_wifi]
    @device.version              = params[:device][:version]

    @device.save! # CHECK required?
    @device.register!

    render json: @device.provisioning_data.to_json
  end


  # Desktop App: Poll
  # PUT /api/devices/:id
  def update
    @device = Device.find_by(identifier: params[:id])

    return render status: 404, text: "404 - Not found" if @device.nil?

    # act as a proxy for the regular heartbeat logic
    Faye.publish_to '/heartbeat',
                    identifier: @device.identifier,
                    interval: @device.heartbeat_interval

    # # payload might carry an event
    # if event = params[:event]
    #   @device.send("can_#{event}?") and @device.send("#{event}!")
    # end

    render json: @device.details
  end

  private

  def device_params
    params.require(:device).permit(:identifier, :type)
  end

end
