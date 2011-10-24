require File.expand_path(File.dirname(__FILE__) + '/../utilities')
require File.expand_path(File.dirname(__FILE__) + '/../apache/manage')

Capistrano::Configuration.instance(true).load do
  set :base_ruby_path, '/usr'
  set :confd_passenger_filename, 'passenger'

  namespace :passenger do
    desc "Installs Phusion Passenger"
    task :install, :roles => :app do
      puts 'Installing passenger module'
      enable_apache_module
      update_config
    end
    
    desc "install build-essentials package"
    task :install_build_essential do
      utilities.apt_install 'build-essential'
    end
    before "passenger:install", "passenger:install_build_essential"

    desc "Setup Passenger Module"
    task :enable_apache_module, :roles => :app do
      sudo "#{base_ruby_path}/bin/gem install passenger --no-ri --no-rdoc"
      sudo "#{base_ruby_path}/bin/passenger-install-apache2-module --auto"
    end

    desc "Configure Passenger"
    task :update_config, :roles => :app do
      version = 'ERROR' # default

      # passenger (2.X.X, 1.X.X)
      run("gem list | grep passenger") do |ch, stream, data|
        version = data.sub(/passenger \(([^,]+).*?\)/,"\\1").strip
      end

      puts "  passenger version #{version} configured"

      passenger_config =<<-EOF
        LoadModule passenger_module #{base_ruby_path}/lib/ruby/gems/1.8/gems/passenger-#{version}/ext/apache2/mod_passenger.so
        PassengerRoot #{base_ruby_path}/lib/ruby/gems/1.8/gems/passenger-#{version}
        PassengerRuby #{base_ruby_path}/bin/ruby
      EOF

      put passenger_config, "/tmp/passenger"
      sudo "mv /tmp/passenger /etc/apache2/conf.d/#{confd_passenger_filename}"
      apache.restart
    end

    # if you want to add more options, try this, in your own conifg
    # read this first... http://www.modrails.com/documentation/Users%20guide.html
    #    namespace :passenger do
    #      task :add_custom_configuration, :roles=>:app do
    #        #512 - 100(stack) - 4*100(instance)
    #        passenger_config = <<EOF
    #    PassengerMaxPoolSize 4
    #    PassengerPoolIdleTime 3000
    #    EOF
    #        put passenger_config, "/tmp/passenger"
    #        sudo "cat /tmp/passenger >> /etc/apache2/conf.d/passenger"
    #        apache.restart
    #      end
    #    end
    #    after "passenger:update_config", *%w(
    #      passenger:add_custom_configuration
    #    )
  end
end