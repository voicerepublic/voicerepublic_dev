namespace :thinking_sphinx do

  desc 'Configure and start TS'
  task :config_start => :app_env do
    Rake::Task["thinking_sphinx:configure"].invoke
    Rake::Task["thinking_sphinx:running_start"].invoke
  end

  desc "Run TS in the foreground (for something like foreman)"
  task :run_in_foreground => ['ts:conf'] do
    ts = ThinkingSphinx::Configuration.instance
    unless pid = fork
      cmd = "#{ts.bin_path}#{ts.searchd_binary_name} --pidfile --config #{ts.config_file} --nodetach"
      puts cmd
      exec cmd
    end
    Signal.trap('TERM') { Process.kill('TERM', pid) }
    Signal.trap('INT')  { Process.kill('INT', pid) }
    Process.wait(pid)
  end
end
