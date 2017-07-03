class Prapi::InstancesController < ApplicationController

  skip_before_action :verify_authenticity_token

  def update
    instance = Instance.find_by(client_token: params[:id])
    instance.assign_attributes(instance_params)
    event = instance.event
    event = :save unless Instance.available_events.include?(event.to_sym)
    instance.send("#{event}!")
    head :ok
  rescue
    head :conflict
  end

  private

  def instance_params
    params.require(:instance).permit(:event, :public_ip_address)
  end

end
