class profile::myapp::v3 {

  include profile::myapp::core

  file { '/opt/myapp/index.php':
    ensure  => file,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => 'puppet:///modules/profile/myapp/v3/index.php',
  }

  file { '/opt/myapp/load.php':
    ensure  => file,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => 'puppet:///modules/profile/myapp/v3/load.php',
  }

}
