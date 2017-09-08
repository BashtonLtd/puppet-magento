# Installs dependencies for Magento if they don't already exist
class magento::dependencies ($addepel = false) {

  case $::osfamily{
    'RedHat': {
      if ($::magento::addepel) {
        include ::epel
      }
      if ($::magento::php54) {
        # Using SCL
        $phpprefix = 'php54-php'
        $phpmysql = 'php54-php-mysqlnd'
        $package = 'php54-php-fpm'
        $service = 'php54-php-fpm'
        $config = '/opt/rh/php54/root/etc/php-fpm.d/www.conf'
      } else {
        $phpprefix = 'php'
        $phpmysql = 'php-mysql'
        $package = 'php-fpm'
        $service = 'php-fpm'
        $config = '/etc/php-fpm.d/www.conf'
      }
      $packages = [
        $phpmysql,
        "${phpprefix}-pdo",
        "${phpprefix}-gd",
        "${phpprefix}-soap",
        "${phpprefix}-mbstring",
        "${phpprefix}-mcrypt",
        "${phpprefix}-xml",
      ]
    }
    default: {
      fail('Sorry, only EL6 is currently supported')
    }
  }

  class { '::nginx':
    server_tokens => 'off',
  }

  class { '::phpfpm':
    user    => 'nginx',
    package => $package,
    service => $service,
    config  => $config,
  }

  contain ::phpfpm

  # Notify phpfpm after any package installation
  ensure_packages($packages)
  Package[$packages] ~> Class['phpfpm']
}
