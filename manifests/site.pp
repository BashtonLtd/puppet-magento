# Creates an nginx vhost for a Magento site

define magento::site (
  $webroot,
  $server_name = [$name],
  $include_files = [],
  $cgi_timeout = '1m',
  $cgi_buffering = 'on',
  $cgi_buffers = '8 4k',
) {

  nginx::resource::vhost { $name:
    www_root      => $webroot,
    try_files     => ['$uri', '$uri/', '/index.php?$args'],
    index_files   => ['index.html', 'index.php',],
    server_name   => $server_name,
    include_files => $include_files,
    conditions    => [
      'if ($http_x_forwarded_proto = "https") { set $elb_https on; }'
    ],
  }

  nginx::resource::location { "${name}-php":
    vhost                     => $name,
    www_root                  => $webroot,
    location                  => '~ \.php$',
    fastcgi                   => '127.0.0.1:9000',
    try_files                 => ['$uri', '=404',],
    location_cfg_append       => {
      fastcgi_param           => 'HTTPS    $elb_https',
      fastcgi_connect_timeout => $cgi_timeout,
      fastcgi_read_timeout    => $cgi_timeout,
      fastcgi_send_timeout    => $cgi_timeout,
      fastcgi_buffering       => $cgi_buffering,
      fastcgi_buffers         => $cgi_buffers,
    }
  }

  $denied = {
    "${name} app"          => { location => '^~ /app/' },
    "${name} includes"     => { location => '^~ /includes/' },
    "${name} lib"          => { location => '^~ /lib/' },
    "${name} downloadable" => { location => '^~ /media/downloadable/' },
    "${name} pkginfo"      => { location => '^~ /pkginfo/' },
    "${name} report"       => { location => '^~ /report/config.xml' },
    "${name} var"          => { location => '^~ /var/' }
  }
  $denied_properties = {
    www_root      => $webroot,
    vhost         => $name,
    location_deny => [ 'all' ],
  }

  create_resources(nginx::resource::location, $denied, $denied_properties)

  # Don't serve htaccess etc to users
  nginx::resource::location { "${name} dotfiles":
    www_root            => $webroot,
    vhost               => $name,
    location            => '/.',
    location_cfg_append => {
      return => '404',
    }
  }

}
