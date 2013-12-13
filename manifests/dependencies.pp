# Installs dependencies for Magento if they don't already exist
class magento::dependencies ($addepel = false) {

  case $::osfamily{
    'RedHat': {
      if ($addepel) {
        include epel
      }
      ensure_packages([
        'php-mysql',
        'php-pdo',
        'php-gd',
        'php-mcrypt',
        'php-xml'
      ])}
      default: {
        fail('Sorry, only EL6 is currently supported')
      }
  }

  include nginx
  include phpfpm
}
