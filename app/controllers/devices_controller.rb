# TODO add some form of authorization, it's secure for now as long as
# we have only a view devices, an attacker would have to guess the serial
#
class DevicesController < BaseController

  before_action :authenticate_user!

  layout 'velvet'


  # GET /devices
  #
  # Shows a list of paired devices.
  #
  # Automatically redirects to device if there is exactly one.
  def index
    @devices = current_user.organizations.map(&:devices).flatten

    return redirect_to @devices.first if @devices.count == 1
  end


  # GET /devices/new
  #
  # Optionally takes a pairing code and redirects to show.
  #
  # Used to display options to proceed if none or multiple devices
  # were detected.
  #
  # Automatically redirects to device if there is exactly one.
  def new
    code = params[:device] && params[:device][:pairing_code]
    return redirect_to device_path(id: code) if code

    @devices = Device.online.pairing.with_ip(request.remote_ip)
    @devices = Device.online.pairing if Rails.env.development?

    return redirect_to [:edit, @devices.first] if @devices.count == 1
  end


  # GET /devices/:pairing_code
  #
  # Shows device and its recordings.
  #
  # Additionally used to search for devices by pairing code.
  # Redirects to edit if a device was found.
  # Redirects to new if nothing was found.
  def show
    if params[:id].match(/^\d{4}$/)
      @device = Device.find_by(pairing_code: params[:id])
      return redirect_to [:edit, @device] if @device
      return redirect_to new_device_path, alert: I18n.t('alert.pairing_code_invalid')
    end

    @device = Device.find_by(identifier: params[:id])
    # TODO raise error if @device.nil?
  end


  # GET /devices/:identifier/edit
  #
  # Display form to name (and thus claim) the device for an organization.
  def edit
    @device = Device.find_by(identifier: params[:id])

    @organization_id = current_user.organizations.first.id
    @names, @suggestions = {}, {}
    current_user.organizations.each do |org|
      @names[org.id] = org.device_names * ', '
      @suggestions[org.id] = org.device_name_suggestion
    end
  end


  # PUT /devices/:identifier
  #
  # Complete pairing, redirect to venues.
  def update
    @device = Device.find_by(identifier: params[:id])
    @device.assign_attributes(devices_params)
    @device.organization_id ||= current_user.organizations.first.id
    @device.complete_pairing!

    redirect_to :venues
  end

  private

  def devices_params
    params.require(:device).permit(:name, :organization_id)
  end

  def suggest_next_name
  end

end
