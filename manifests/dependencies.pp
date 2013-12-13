# Installs dependencies for Magento if they don't already exist
class magento::dependencies ($addepel = false) {

  case $::osfamily{
    'RedHat': {
      if ($addepel) {
        include epel
      }
      $packages = [
        'php-mysql',
        'php-pdo',
        'php-gd',
        'php-mcrypt',
        'php-xml'
      ]
    }
    default: {
      fail('Sorry, only EL6 is currently supported')
    }
  }

  include nginx
  class { 'phpfpm':
    user => 'nginx',
  }

  # Notify phpfpm after any package installation
  ensure_packages[$packages]
  Package[$packages] ~> Class['phpfpm']
}
