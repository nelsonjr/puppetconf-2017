#    ___                        _     ___             __   ____   ___  _ _____ 
#   / _ \_   _ _ __  _ __   ___| |_  / __\___  _ __  / _| |___ \ / _ \/ |___  |
#  / /_)/ | | | '_ \| '_ \ / _ \ __|/ /  / _ \| '_ \| |_    __) | | | | |  / / 
# / ___/| |_| | |_) | |_) |  __/ |_/ /__| (_) | | | |  _|  / __/| |_| | | / /  
# \/     \__,_| .__/| .__/ \___|\__\____/\___/|_| |_|_|   |_____|\___/|_|/_/   
#             |_|   |_|                                                        

gauth_credential { 'mycred':
  path     => $cred_path, # e.g. '/home/nelsonjr/my_account.json'
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

gcompute_instance_template { 'zero-to-prod-10-it':
  ensure     => present,
  properties => {
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
    # XXX XXX XXX XXX 
    # |    metadata           => [
    # |      {
    # |        # A startup script that installs the CA certificate, Google Cloud
    # |        # Logging, and defer to Puppet Agent installer script.
    # |        'startup-script-url'     =>
    # |          'gs://graphite-demo-puppetconf-17-1/bootstrap.sh',
    # |        # The URL of the Puppet Agent installer
    # |        'puppet-agent-installer' =>
    # |          "https://${master_server}:8140/packages/current/install.bash",
    # |        # A trusted location where to fetch CA certificate (if not publicly
    # |        # trusted, or trusted by the image being deployed already).
    # |        'puppet-ca-cert'         =>
    # |          'gs://graphite-demo-puppetconf-17-1/puppet-ca-cert.pem',
    # |      },
    # |    ],
    metadata => {
      items  => [
        {
          # A startup script that installs the CA certificate, Google Cloud
          # Logging, and defer to Puppet Agent installer script.
          key   => 'startup-script-url',
          value => 'gs://graphite-demo-puppetconf-17-1/bootstrap.sh',
        },
        {
          # The URL of the Puppet Agent installer
          key   => 'puppet-agent-installer',
          value => "https://${master_server}:8140/packages/current/install.bash",
        },
        {
          # A trusted location where to fetch CA certificate (if not publicly
          # trusted, or trusted by the image being deployed already).
          key   => 'puppet-ca-cert',
          value => 'gs://graphite-demo-puppetconf-17-1/puppet-ca-cert.pem',
        },
      ],
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
  },
  project    => 'graphite-demo-puppetconf-17-1',
  credential => 'mycred',
}

gcompute_firewall { 'zero-to-prod-10-fw-hc':
  ensure  => present,
  allowed => [
    {
      ip_protocol => 'tcp',
      ports       => [
        '80',
      ],
    },
  ],
  target_tags => [
    'zero-to-prod-10-hc-target',
  ],
  source_ranges => [
    '209.85.152.0/22',
    '209.85.204.0/22',
    '35.191.0.0/16',
    '130.211.0.0/22',
  ],
  project    => 'graphite-demo-puppetconf-17-1',
  credential => 'mycred',
}

gcompute_http_health_check { 'zero-to-prod-10-hc':
  ensure              => present,
  healthy_threshold   => 10,
  port                => 80,
  timeout_sec         => 2,
  unhealthy_threshold => 5,
  project             => 'graphite-demo-puppetconf-17-1',
  credential          => 'mycred',
}

gcompute_target_pool { 'zero-to-prod-10-tp':
  ensure       => present,
  health_check => 'zero-to-prod-10-hc',
  region       => 'us-west1',
  project      => 'graphite-demo-puppetconf-17-1',
  credential   => 'mycred',
}

gcompute_instance_group_manager { 'zero-to-prod-10-mig':
  ensure             => present,
  base_instance_name => 'zero-to-prod-10-vm',
  instance_template  => 'zero-to-prod-10-it',
  target_size        => 3,
  target_pools       => [
    'zero-to-prod-10-tp',
  ],
  zone               => 'us-west1-a',
  project            => 'graphite-demo-puppetconf-17-1',
  credential         => 'mycred',
}
