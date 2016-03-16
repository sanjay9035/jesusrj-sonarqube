# Class: sonarqube::params
#
# This module manages sonarqube parameters
#
# Parameters:
#
# None.
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class sonarqube::params {
  $version = 'latest'
  $service_enable = true
  $service_ensure = 'running'
  $install_java = true

  case $::osfamily {
    'Debian': {
      $package_provider = 'dpkg'
      $service_provider = undef
    }
    'RedHat': {
      $package_provider = 'rpm'
      case $::operatingsystem {
        'Fedora': {
          if versioncmp($::operatingsystemrelease, '19') >= 0 or $::operatingsystemrelease == 'Rawhide' {
            $service_provider = 'redhat'
          }
        }
        /^(RedHat|CentOS|Scientific|OracleLinux)$/: {
          if versioncmp($::operatingsystemmajrelease, '7') >= 0 {
            $service_provider = 'redhat'
          }
        }
        default: {
          $service_provider = undef
        }
      }
    }
    default: {
      $package_provider = undef
      $service_provider = undef
    }
  }
}
