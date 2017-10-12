plan profile::app($ensure = 'up') {
  case $ensure {
    up: {
      run_task(profile::up_app_instances, 'localhost')
      run_task(profile::up_app_dns, 'localhost')
      notice('Infrastructure up')
    }
    down: {
      run_task(profile::down_app, 'localhost')
      notice('Infrastructure down')
    }
  } 
}
