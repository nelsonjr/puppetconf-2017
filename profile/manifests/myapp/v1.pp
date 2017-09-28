class profile::myapp::v1 {

  include profile::myapp::core

  file { '/opt/myapp/index.php':
    ensure  => file,
    content => join(
      [
        '<?php',
        "header('X-Source: ' . gethostname());",
        "header('X-Version: 1.0');",
        "header('Content-Type: text/plain');",
        '?>',
        ' _____                        _    _____             __   __ ______ ',
        '|  __ \                      | |  / ____|           / _| /_ |____  |',
        '| |__) |   _ _ __  _ __   ___| |_| |     ___  _ __ | |_   | |   / / ',
        '|  ___/ | | | \'_ \| \'_ \ / _ \ __| |    / _ \| \'_ \|  _|  | |  / /  ',
        '| |   | |_| | |_) | |_) |  __/ |_| |___| (_) | | | | |    | | / /   ',
        '|_|    \__,_| .__/| .__/ \___|\__|\_____\___/|_| |_|_|    |_|/_/    ',
        '            | |   | |                                               ',
        '            |_|   |_|                                               ',
        '',
        '<?php',
        "echo 'Hello from ' . gethostname() . '!';",
        'echo "\n\n";',
        "echo 'It\\'s ' . date('r') . ' around here';",
        '?>',
      ], "\n"
    ),
  }

}
