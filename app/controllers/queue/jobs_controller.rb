# integer  "priority",               default: 0, null: false
# integer  "attempts",               default: 0, null: false
# text     "handler",                            null: false
# text     "last_error"
# datetime "run_at"
# datetime "locked_at"
# datetime "failed_at"
# string   "locked_by",  limit: 255
# string   "queue",      limit: 255
# datetime "created_at"
# datetime "updated_at"
#
# The worker
# 1. get list of available jobs
# 2. if empty terminate (if at least on job has been fullfilled otherwise wait)
# 3. if not empty get first
# 4. try to claim first
# 5. if successfully claimed work on it
# 6. if failed claiming it continue at 1
# 7. when done working on it delete job & continue at 1
#
class Queue::JobsController < ApplicationController

  # list available jobs
  def index
    render json: available_jobs
  end

  # claim
  def update
    job = Delayed::Job.find(params[:id])
    begin
      transaction do
        job.reload
        raise 'already taken' unless job.locked_by.nil?
        job.locked_by = params[:worker_id]
        job.locked_at = Time.now
        save!
      end
      head :ok
    rescue
      head :conflict
    end
  end

  # fullfilled
  def destroy
    job = Delayed::Job.find(params[:id])
    if job.destroy!
      head :ok
    else
      head :conflict
    end
  end

  private

  def available_jobs
    # atm only used for audio
    Delayed::Job.where(queue: 'audio')
      .where(locked_by: nil)
      .order('created_at ASC')
  end

end
