define magento::site (
  $webroot,
  $server_name = $name
) {

  nginx::resource::vhost { $name:
    www_root    => $webroot,
    try_files   => '$uri $uri/ /index.php?$args',
    index_files => ['index.html', 'index.php',],
    server_name => $server_name,
  }

  nginx::resource::location { "${name}-php":
    vhost     => $name,
    www_root  => $webroot,
    location  => '~ \.php$',
    fastcgi   => '127.0.0.1:9000',
    try_files => '$uri =404';
  }

}
