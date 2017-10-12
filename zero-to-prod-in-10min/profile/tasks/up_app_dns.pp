#!/opt/puppetlabs/bin/puppet apply
#    ___                        _     ___             __   ____   ___  _ _____ 
#   / _ \_   _ _ __  _ __   ___| |_  / __\___  _ __  / _| |___ \ / _ \/ |___  |
#  / /_)/ | | | '_ \| '_ \ / _ \ __|/ /  / _ \| '_ \| |_    __) | | | | |  / / 
# / ___/| |_| | |_) | |_) |  __/ |_/ /__| (_) | | | |  _|  / __/| |_| | | / /  
# \/     \__,_| .__/| .__/ \___|\__\____/\___/|_| |_|_|   |_____|\___/|_|/_/   
#             |_|   |_|                                                        

gauth_credential { 'mycred':
  path     => '/home/ody/my_account.json',
  provider => serviceaccount,
  scopes   => [
    'https://www.googleapis.com/auth/compute',
    'https://www.googleapis.com/auth/ndev.clouddns.readwrite',
  ],
}

# Fetch the IP address of the VM
$fn_auth = gauth_credential_serviceaccount_for_function(
  '/home/ody/my_account.json',
  ['https://www.googleapis.com/auth/compute.readonly']
)

$ip_address = gcompute_address_ip('zero-to-prod-10-app-ip', 'us-west1',
                                  'graphite-demo-puppetconf-17-1', $fn_auth)

if (!$ip_address) {
  warning('IP address not available in this run. Apply manifest again.')
} else {
  info("VM IP address = ${ip_address}")

  gdns_managed_zone { 'app-puppetconf17':
    ensure      => present,
    dns_name    => 'puppetconf17.cloudnativeapp.com.',
    project     => 'graphite-demo-puppetconf-17-1',
    credential  => 'mycred',
  }

  gdns_resource_record_set { 'www.puppetconf17.cloudnativeapp.com.':
    ensure       => present,
    managed_zone => 'app-puppetconf17',
    type         => 'A',
    ttl          => 5,
    target       => $ip_address,
    project      => 'graphite-demo-puppetconf-17-1',
    credential   => 'mycred',
  }
}
