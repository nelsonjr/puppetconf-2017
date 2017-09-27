class profile::myapp {

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

  file { '/opt/myapp/index.php':
    ensure  => file,
    content => join(
      [
        '<?php',
        "header('X-Source: ' . gethostname());",
        "echo 'Hello from ' . gethostname() . '!';",
        '?>',
      ], "\n"
    ),
  }

  file { '/opt/myapp/status.php':
    ensure  => file,
    content => '<?php echo "OK " . time(); ?>',
  }

}
