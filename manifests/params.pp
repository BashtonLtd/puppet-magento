# Handles class-level params
class magento::params {
  case $::osfamily {
    'RedHat': {

      if $::magento::php54 {
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
}
