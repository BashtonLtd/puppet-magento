# == Class: magento
#
# Installs dependencies for Magento and creates suitable webserver config
#
# === Parameters
#
# Document parameters here.
#
# [*addepel*]
#
# Add the EPEL repos
#
# === Examples
#
#  class { magento:
#  }
#
# === Authors
#
# Sam Bashton <sam@bashton.com>
#
# === Copyright
#
# Copyright 2013 Bashton Ltd
#
class magento (
  $addepel = false,
  $php54 = false
) {

  contain ::magento::dependencies

}
