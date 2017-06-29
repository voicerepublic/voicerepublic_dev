class Prapi::JobsController < ApplicationController

  # list available jobs
  def index
    render json: available_jobs
  end

  # claim & start, finish
  def update
    job = Job.find(params[:id])
    job.assign_attributes(job_params)
    event = job.event.to_sym
    event = :save unless Job.available_events.include?(event)
    job.send("#{event}!")
    head :ok
  rescue
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
