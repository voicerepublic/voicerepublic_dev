class DevicesController < ApplicationController

  layout 'velvet'

  # load_and_authorize_resouce

  def index
    @devices = Device.online.pairing.with_ip(request.remote_ip)
    @devices = Device.online.pairing if Rails.env.development?
    return redirect_to [:edit, @devices.first] if @devices.count == 1
  end

  def edit
    @device = Device.find_by(identifier: params[:id])
  end

  def update
    @device = Device.find_by(identifier: params[:id])
    @device.organization_id = current_user.organizations.first.id
    @device.update_attributes(devices_params)

    redirect_to :venues
  end

  private

  def devices_params
    params.require(:device).permit(:name, :organization_id)
  end

end
