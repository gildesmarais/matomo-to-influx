job_type :command, ':task'

every 1.minute do
  command '/usr/local/bin/ruby /app/app.rb'
end
