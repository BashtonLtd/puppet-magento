# Creates an nginx vhost for a Magento site

define magento::site (
  $webroot,
  $server_name = [$name]
) {

  nginx::resource::vhost { $name:
    www_root          => $webroot,
    try_files         => '$uri $uri/ /index.php?$args',
    index_files       => ['index.html', 'index.php',],
    server_name       => $server_name,
    conditions        => [
      'if ($http_x_forwarded_proto = "https") { set $elb_https on; }'
    ],
  }

  nginx::resource::location { "${name}-php":
    vhost               => $name,
    www_root            => $webroot,
    location            => '~ \.php$',
    fastcgi             => '127.0.0.1:9000',
    try_files           => ['$uri', '=404',],
    location_cfg_append => {
      fastcgi_param     => 'HTTPS    $elb_https'
    }
  }

  $denied = [
    '^~ /app/',
    '^~ /includes/',
    '^~ /lib/',
    '^~ /media/downloadable/',
    '^~ /pkginfo/',
    '^~ /report/config.xml',
    '^~ /var/'
  ]

  nginx::resource::location { $denied:
    www_root      => $webroot,
    vhost         => $name,
    location_deny => [ 'all' ],
  }

  # Don't serve htaccess etc to users
  nginx::resource::location { 'dotfiles':
    www_root            => $webroot,
    vhost               => $name,
    location            => '/.',
    location_cfg_append => {
      return => '404',
    }
  }

}
