Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.default_priority = 20
Delayed::Worker.default_queue_name = 'default'
Delayed::Worker.delay_jobs = !Rails.env.test?
Delayed::Worker.max_attempts = 1

dj_log_path = Rails.root.join("log/dj-#{Process.pid}.log")
dj_log_path = Rails.root.join("log/dj-#{Process.pid}.log") if Rails.env.production?
Delayed::Worker.logger = Logger.new(dj_log_path)
