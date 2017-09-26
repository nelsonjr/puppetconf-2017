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
  project    => 'google.com:graphite-playground',
  credential => 'mycred',
}

gcompute_region { 'us-west1':
  project    => 'google.com:graphite-playground',
  credential => 'mycred',
}

gcompute_network { 'default':
  project    => 'google.com:graphite-playground',
  credential => 'mycred',
}

gcompute_machine_type { 'n1-standard-1':
  zone       => 'us-west1-a',
  project    => 'google.com:graphite-playground',
  credential => 'mycred',
}

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
    ]
  },
  project    => 'google.com:graphite-playground',
  credential => 'mycred',
}

gcompute_http_health_check { 'zero-to-prod-10-hc':
  ensure              => present,
  healthy_threshold   => 10,
  port                => 80,
  timeout_sec         => 2,
  unhealthy_threshold => 5,
  project             => 'google.com:graphite-playground',
  credential          => 'mycred',
}

gcompute_target_pool { 'zero-to-prod-10-tp':
  ensure       => present,
  health_check => 'zero-to-prod-10-hc',
  region       => 'us-west1',
  project      => 'google.com:graphite-playground',
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
  project            => 'google.com:graphite-playground',
  credential         => 'mycred',
}
