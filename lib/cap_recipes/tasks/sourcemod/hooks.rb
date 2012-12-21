Capistrano::Configuration.instance(true).load do

  after "hlds:setup", "sourcemod:install_metamod"
  after "sourcemod:install_metamod", "sourcemod:install_sourcemod"

end