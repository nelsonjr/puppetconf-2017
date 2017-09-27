class profile::myapp::v2 {

  include profile::myapp::core

  file { '/opt/myapp/index.php':
    ensure  => file,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => 'puppet:///modules/profile/myapp/v2/index.php',
  }

  file { '/opt/myapp/google-cloud-platform-logo.png':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => 'puppet:///modules/profile/google-cloud-platform-logo.png',
  }

  file { '/opt/myapp/puppetconf-logo.png':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => 'puppet:///modules/profile/puppetconf-logo.png',
  }

}
