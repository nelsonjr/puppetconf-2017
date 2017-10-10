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
}
