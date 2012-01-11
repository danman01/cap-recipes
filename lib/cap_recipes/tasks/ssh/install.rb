Capistrano::Configuration.instance(true).load do

  namespace :ssh_issue do
    set :issue_net, File.join(File.dirname(__FILE__),'issue.net')

    desc "Setup and Configure issue.net and sshd_config"
    task :install do
      utilities.sudo_upload_template issue_net, "/etc/issue.net", :mode => "644", :owner => 'root:root'
       sudo %Q{sed -i "s/#*Banner.*/Banner \\\/etc\\\/issue.net/g" /etc/ssh/sshd_config }
       sudo %Q{sed -i "s/PrintLastLog yes/PrintLastLog no/g" /etc/ssh/sshd_config }
    end

    desc "Restart SSH"
    task :restart do
      utilities.run_compressed %Q{
        #{sudo} /etc/init.d/ssh restart
      }
    end
  end
end