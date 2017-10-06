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
  ],
}

gcompute_zone { 'us-west1-a':
  project    => 'graphite-demo-puppetconf-17-1',
  credential => 'mycred',
}

gcompute_region { 'us-west1':
  project    => 'graphite-demo-puppetconf-17-1',
  credential => 'mycred',
}

gcompute_network { 'default':
  project    => 'graphite-demo-puppetconf-17-1',
  credential => 'mycred',
}

gcompute_machine_type { 'n1-standard-1':
  zone       => 'us-west1-a',
  project    => 'graphite-demo-puppetconf-17-1',
  credential => 'mycred',
}

$master_server = 'puppet.c.graphite-demo-puppetconf-17-1.internal'
info("Puppet Master @ ${master_server}")

gcompute_instance { 'zero-to-prod-10-app':
  ensure             => present,
  machine_type       => 'n1-standard-1',
  disks              => [
    {
      # Auto delete will prevent disks from being left behind on deletion.
      auto_delete       => true,
      boot              => true,
      initialize_params => {
        source_image =>
          gcompute_image_family('ubuntu-1604-lts', 'ubuntu-os-cloud'),
      }
    }
  ],
  metadata           => {
    # A startup script that installs the CA certificate, Google Cloud
    # Logging, and defer to Puppet Agent installer script.
    'startup-script-url'     =>
      'gs://graphite-demo-puppetconf-17-1/bootstrap.sh',
    # The URL of the Puppet Agent installer
    'puppet-agent-installer' => 
      "https://${master_server}:8140/packages/current/install.bash",
    # A trusted location where to fetch CA certificate (if not publicly
    # trusted, or trusted by the image being deployed already).
    'puppet-ca-cert'         => 
      'gs://graphite-demo-puppetconf-17-1/puppet-ca-cert.pem',
  },
  network_interfaces => [
    {
      access_configs => [
        {
          name => 'External NAT',
          type => 'ONE_TO_ONE_NAT',
        },
      ],
      network        => 'default',
    }
  ],
  service_accounts   => [
    {
      scopes => [
        # Enable Cloud Storage so we can access the bootstrap.sh startup script.
        'https://www.googleapis.com/auth/devstorage.read_only',

        # Enable Stackdriver Logging API access
        'https://www.googleapis.com/auth/logging.write',
      ],
    },
  ],
  # In a future release tags will be replaced to be a straight array instead
  # of tags { items [ .... ] }
  tags               => {
    items => [
      # Default firewall rule only allows HTTP access to machines with
      # http-server tag attached to them.
      'http-server',
      # We allow Health Checker to reach machines tagged with this
      'zero-to-prod-10-hc-target',
    ],
  },
  zone               => 'us-west1-a',
  project            => 'graphite-demo-puppetconf-17-1',
  credential         => 'mycred',
}
