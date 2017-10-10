class profile::myapp::core {

  include apache
  include apache::mod::php

  file { '/opt/myapp':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  apache::vhost { 'myapp':
    port    => '80',
    docroot => '/opt/myapp',
    aliases => [
      {
        scriptalias => '/status',
        path        => '/opt/myapp/status.php',
      },
    ],
  }

  file { '/opt/myapp/status.php':
    ensure  => file,
    content => '<?php echo "OK " . time(); ?>',
  }

}
