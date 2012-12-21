# @author Rick Russell <sysadmin.rick@gmail.com>

Capistrano::Configuration.instance(true).load do

  namespace :sourcemod do 

    roles[:sourcemod]
    set :hlds_root, "/opt/hlds"
    set(:hlds_source) {hlds_root}
    set :hlds_user, "hlds"
    set :hlds_metamod_url, "http://www.n00bsalad.net/sourcemodmirror/mmsource-1.9.0-linux.tar.gz"
    set(:hlds_metamod_dir) { "#{hlds_addons_dir}/metamod" }
    set(:hlds_source_dir) { "#{hlds_addons_dir}/sourcemod" }
    set(:hlds_bindir) { "#{hlds_root}/orangebox" }
    set(:hlds_addons_dir) { "#{hlds_bindir}/tf/addons" }
    set :hlds_metamod_vdf, File.join(File.dirname(__FILE__),'metamod.vdf')

    set(:hlds_config_root) { "#{hlds_root}/orangebox/tf/cfg" }
    set(:hlds_config_server_cfg) { "#{hlds_config_root}/server.cfg" }
   
    set(:hlds_config_rcon_password) {utilities.ask("rcon_password") }
    set :hlds_config_sv_password, nil # connect password
    set :hlds_config_tf_server_identity_account_id, nil
    set :hlds_config_tf_server_identity_token, nil


    task :install_metamod, :roles => [:hlds, :hlds_event, :hlds_ugc] do
      run "#{sudo} mkdir -p #{hlds_addons_dir}"
      run "cd #{hlds_addons_dir} && #{sudo} wget --tries=2 -c --progress=bar:force #{hlds_metamod_url}"
      run "#{sudo} chown -R #{hlds_user}:#{hlds_user} #{hlds_root}"
    end

    task :setup, :roles => [:hlds, :hlds_event, :hlds_ugc] do
      utilities.sudo_upload_template hlds_init_erb, hlds_init_dest, :owner => "root:root", :mode => "700"
      utilities.sudo_upload_template hlds_steam_appid_erb, hlds_steam_appid_erb_path, :owner => "#{hlds_user}:#{hlds_user}"
      utilities.sudo_upload_template hlds_config_erb, hlds_config_server_cfg, :owner => "#{hlds_user}:#{hlds_user}"
      utilities.sudo_upload_template hlds_motd_txt_erb, "#{hlds_bindir}/tf/motd.txt", :owner => "#{hlds_user}:#{hlds_user}"
      utilities.sudo_upload_template hlds_motd_text_txt_erb, "#{hlds_bindir}/tf/motd_text.txt", :owner => "#{hlds_user}:#{hlds_user}"
      put hlds_mapcycle.join("\n")+"\n", "/tmp/mapcycle.txt", :owner => "#{hlds_user}:#{hlds_user}"
      run "#{sudo} cp #{hlds_bindir}/tf/mapcycle.txt #{hlds_bindir}/tf/mapcycle.txt.`date +%s`"
      run "#{sudo} mv /tmp/mapcycle.txt #{hlds_bindir}/tf/mapcycle.txt"
    end

  end
end