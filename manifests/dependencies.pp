# Installs dependencies for Magento if they don't already exist
class magento::dependencies {

  class { '::nginx':
    server_tokens => 'off',
  }

  class { '::phpfpm':
    user    => 'nginx',
    package => $::magento::params::package,
    service => $::magento::params::service,
    config  => $::magento::params::config,
  }

  contain ::phpfpm

  # Notify phpfpm after package installation
  ensure_packages($::magento::params::packages)
  Package[$::magento::params::packages] {
    notify => Class['::phpfpm']
  }
}
