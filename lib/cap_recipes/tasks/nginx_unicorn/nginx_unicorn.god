God.watch do |w|
  w.name = "nginx_unicorn"
  w.group = "nginx"
  w.interval = 5.seconds # default
  w.start = "/etc/init.d/<%=nginx_unicorn_init_d%> start"
  w.stop = "/etc/init.d/<%=nginx_unicorn_init_d%> stop"
  w.restart = "/etc/init.d/<%=nginx_unicorn_init_d%> restart"
  w.pid_file = "/var/run/<%=nginx_unicorn_init_d%>.pid"
  
  # clean pid files before start if necessary
  w.behavior(:clean_pid_file)
  
  # determine the state on startup
  w.transition(:init, { true => :up, false => :start }) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end
  end
  
  # determine when process has finished starting
  w.transition([:start, :restart], :up) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end
    
    # failsafe
    on.condition(:tries) do |c|
      c.times = 5
      c.transition = :start
    end
  end

  # start if process is not running
  w.transition(:up, :start) do |on|
    on.condition(:process_exits) do |c|
      c.notify = %w[ <%=god_notify_list%> ]
    end
  end

  # lifecycle
  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 5.minute
      c.transition = :unmonitored
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
      c.notify = %w[ <%=god_notify_list%> ]
    end
  end
end