# TODO add some form of authorization, it's secure for now as long as
# we have only a view devices, an attacker would have to guess the serial
#
class DevicesController < ApplicationController

  layout 'velvet'

  # GET /devices
  #
  # Used to display all devices ready for pairing.
  #
  # Automatically redirects to device if there is exactly one.
  def index
    @devices = Device.online.pairing.with_ip(request.remote_ip)
    @devices = Device.online.pairing if Rails.env.development?
    return redirect_to [:edit, @devices.first] if @devices.count == 1
  end

  # GET /devices/:identifier/edit
  #
  # Display form to name (and thus claim) the device for an organization.
  def edit
    @device = Device.find_by(identifier: params[:id])
  end

  # PUT /devices/:identifier
  #
  # Complete pairing, redirect to venues.
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
