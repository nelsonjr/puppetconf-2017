plan profile::lnb_app($ensure = 'up', $production = false) {
  case $ensure {
    up: {
      run_task(profile::up_lnb_app_instances, 'localhost')
      run_task(profile::up_lnb_app_dns, 'localhost',
               { production => $production })
      if $production {
        notice('Staging infrastructure up')
      } else {
        notice('Production infrastructure up')
      }
    }
    down: {
      run_task(profile::down_lnb_app, 'localhost')
      notice('Infrastructure down')
    }
  } 
}
