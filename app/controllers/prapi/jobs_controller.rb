class Prapi::JobsController < ApplicationController

  respond_to :json

  skip_before_action :verify_authenticity_token

  # list available jobs
  def index
    render json: available_jobs
  end

  # claim & start, finish
  def update
    job = Job.find(params[:id])
    job.assign_attributes(job_params)
    event = job.event
    event = :save unless Job.available_events.include?(event.to_sym)
    job.send("#{event}!")
    head :ok
  rescue => e
    logger.error "Error updating Job #{job.id}: #{e.message}"
    head :conflict
  end

  private

  def job_params
    params.require(:job).permit(:event, :locked_by)
  end

  def available_jobs
    Job.pending.ordered
  end

end
