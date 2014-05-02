Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.default_priority = 20
Delayed::Worker.default_queue_name = 'default'
Delayed::Worker.delay_jobs = !Rails.env.test?
Delayed::Worker.max_attempts = 2
