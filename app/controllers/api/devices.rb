class Api::DevicesController < Api::BaseController

  skip_before_action :authenicate_user!

  # POST /api/device
  def create
    @device = Device.find_or_init_by(params)

    @device.public_ip_address = request.remote_ip

    if @device.save
      render json: @device.registration_payload.to_json
    else
      head status: 409
    end
  end

end
