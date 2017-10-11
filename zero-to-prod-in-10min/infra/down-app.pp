#    ___                        _     ___             __   ____   ___  _ _____ 
#   / _ \_   _ _ __  _ __   ___| |_  / __\___  _ __  / _| |___ \ / _ \/ |___  |
#  / /_)/ | | | '_ \| '_ \ / _ \ __|/ /  / _ \| '_ \| |_    __) | | | | |  / / 
# / ___/| |_| | |_) | |_) |  __/ |_/ /__| (_) | | | |  _|  / __/| |_| | | / /  
# \/     \__,_| .__/| .__/ \___|\__\____/\___/|_| |_|_|   |_____|\___/|_|/_/   
#             |_|   |_|                                                        


gauth_credential { 'mycred':
  path     => '/home/nelsona/my_account.json',
  provider => serviceaccount,
  scopes   => [
    'https://www.googleapis.com/auth/compute',
    'https://www.googleapis.com/auth/ndev.clouddns.readwrite',
  ],
}

gcompute_region { 'us-west1':
  project    => 'graphite-demo-puppetconf-17-1',
  credential => 'mycred',
}

gcompute_zone { 'us-west1-a':
  project    => 'graphite-demo-puppetconf-17-1',
  credential => 'mycred',
}

gcompute_instance { 'zero-to-prod-10-app':
  ensure     => absent,
  zone       => 'us-west1-a',
  project    => 'graphite-demo-puppetconf-17-1',
  credential => 'mycred',
  before     => Gcompute_address['zero-to-prod-10-app-ip'],
}

gcompute_address { 'zero-to-prod-10-app-ip':
  ensure     => absent,
  region     => 'us-west1',
  project    => 'graphite-demo-puppetconf-17-1',
  credential => 'mycred',
}

# We do not delete the DNS Zone or it may go out of sync with the parent DNS
# zone (if you must delete the zone make sure you update the parent DNS
# accordingly).
gdns_managed_zone { 'app-puppetconf17':
  ensure      => present,
  dns_name    => 'puppetconf17.cloudnativeapp.com.',
  project     => 'graphite-demo-puppetconf-17-1',
  credential  => 'mycred',
}

gdns_resource_record_set { 'www.puppetconf17.cloudnativeapp.com.':
  ensure       => absent,
  type         => 'A',
  managed_zone => 'app-puppetconf17',
  project      => 'graphite-demo-puppetconf-17-1',
  credential   => 'mycred',
}
