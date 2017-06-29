class Prapi::InstancesController < ApplicationController

  def update
    instance = Instance.find_by(client_token: params[:id])
    instance.assign_attributes(instance_params)
    event = instance.event.to_sym
    event = :save unless Instance.available_events.include?(event)
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
