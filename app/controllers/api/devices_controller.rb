class Api::DevicesController < ApplicationController

  respond_to :json

  skip_before_action :verify_authenticity_token

  TARGETS = Settings.devices.endpoint.to_hash.keys


  # GET /api/devices/:id
  def show
    @device = Device.find_by(identifier: params[:id])

    target = @device.try(:target) || 'live' # fallback to live
    raise "Unknown target: #{target}" unless TARGETS.include?(target.to_sym)

    endpoint = Settings.devices.endpoint[target]

    loglevel = @device.try(:loglevel) || Logger::INFO

    render json: { endpoint: endpoint, loglevel: loglevel }
  end


  # POST /api/devices
  def create
    @device = Device.find_or_initialize_by(device_params)

    @device.public_ip_address = request.remote_ip
    @device.subtype = params[:device][:subtype]

    if @device.save
      render json: @device.provisioning_data.to_json
    else
      head status: 409 # conflict
    end
  end


  def device_params
    params.require(:device).permit(:identifier, :type)
  end

end
