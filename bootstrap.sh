#!/bin/bash

declare -r puppet='/opt/puppetlabs/bin/puppet'

metadata() {
  local -r attr=$1
  local -r metadata_ep='http://metadata/computeMetadata/v1beta1/'
  curl -H Metadata-Flavor:Google "${metadata_ep}/instance/attributes/${attr}"
}

declare -r start_time=$(date +%s)
logger -t bootstrapper 'Starting bootstrap'

#---------
# Install the Puppet Agent (for logging with Stackdriver)
curl -O https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
dpkg -i puppetlabs-release-pc1-xenial.deb
apt-get update
apt-get install -y puppet-agent=1.10.5-1xenial

#---------
# Google Stackdriver Logging Agent

logger -t bootstrapper 'Installing Google Stackdriver logging agent'
${puppet} module install google-glogging
${puppet} apply -e 'include glogging::agent'
logger -t bootstrapper 'Google Stackdriver logging agent installed'

#---------
# Remove agent to not bother master install script

dpkg --purge puppet-agent
dpkg --purge puppetlabs-release-pc1

#---------
# Puppet Master X.509 certificate install

declare -r ca_cert=$(metadata puppet-ca-cert)
declare -r local_ca_cert="${HOME}/puppet-ca.pem"
logger -t bootstrapper "Puppet Master certificate @ ${ca_cert}"
logger -t bootstrapper 'Copying Puppet Master certificate from trusted source'
gsutil cp "${ca_cert}" "${local_ca_cert}"
logger -t bootstrapper Done installing Puppet Master X.509 certificate

#---------
# Defer to Puppet Agent installer

declare -r agent_install=$(metadata puppet-agent-installer)
declare -r local_agent_installer="${HOME}/puppet-agent-install.sh"
logger -t bootstrapper "Deferring to Puppet Agent installer @ ${agent_install}"
curl --cacert "${local_ca_cert}" -o "${local_agent_installer}" \
    "${agent_install}"
chmod +x "${local_agent_installer}"
# Invoke the downloaded Puppet agent installer
"${local_agent_installer}"
logger -t bootstrapper 'Done with Puppet Agent installer'

declare -r end_time=$(date +%s)
logger -t bootstrapper \
  "Bootstrap complete in $((end_time - start_time)) seconds."
