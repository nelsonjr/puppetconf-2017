class profile::myapp::v3 inherits profile::myapp::v2 {

  File['/opt/myapp/index.php'] {
    source => 'puppet:///modules/profile/myapp/v3/index.php',
  }

  file { '/opt/myapp/frame.php':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('profile/myapp/v3/frame.php.erb'),
  }

}
