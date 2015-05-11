module DjHelpers

  def expect_scheduled_job_to_have_run_in_the_future
    expect(Delayed::Job.count).to be >= 1
    Timecop.travel(25.hours.from_now)
    successes, failures = Delayed::Worker.new.work_off
    expect(Delayed::Job.count).to eq(0)
    expect(successes).to be >= 1
    expect(failures).to eq(0)
  end

end
