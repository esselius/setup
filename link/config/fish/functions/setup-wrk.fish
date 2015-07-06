function setup-wrk
  set -x SALTSIDE_SOURCE_DIR ~/code
  set -x WORKSTATION_VAGRANTFILE $SALTSIDE_SOURCE_DIR/platform-workstation/Vagrantfile
  set PATH $SALTSIDE_SOURCE_DIR/platform-workstation/vagrant-workstation/bin/ $PATH
  
  alias wrk workstation
end
