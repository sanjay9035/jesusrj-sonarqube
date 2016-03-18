# == Class: sonarqube
#
# Sonarqube installation and configuration
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'sonarqube':
#  }
#
# === Authors
#
# Author Name <reginaldo.jesus@gmail.com>
#
# === Copyright
#
# Copyright 2016 Reginaldo Jesus (JesusRJ).
#
class sonarqube (
  $version            = $sonarqube::params::version,
  $service_enable     = $sonarqube::params::service_enable,
  $service_ensure     = $sonarqube::params::service_ensure,
  $service_provider   = $sonarqube::params::service_provider,
  $package_provider   = $sonarqube::params::package_provider,
  $install_java       = $sonarqube::params::install_java,
  $configure_firewall = false,
  $config_properties  = {},
  $config_file        = undef,
) inherits sonarqube::params {

  include sonarqube::repo

  validate_string($version)
  validate_bool($service_enable)
  validate_re($service_ensure, '^running$|^stopped$')
  validate_string($service_provider)
  validate_string($package_provider)
  validate_bool($install_java)
  validate_bool($configure_firewall)
  validate_hash($config_properties)
  validate_string($config_file)

  $sonar_home = '/opt/sonar'
  $plugin_home = "${sonar_home}/extensions/plugins/"
  $sonar_properties = "${sonar_home}/conf/sonar.properties"

  if $install_java {
    class {'java':
      distribution => 'jdk',
    }
  }

  package { 'sonar':
    ensure  => $::sonarqube::version,
    require => Class['sonarqube::repo'],
    notify  => Service['sonar'],
  }

  class { 'sonarqube::config':
    require => Package['sonar'],
    notify  => Service['sonar'],
  }

  include sonarqube::service

  if defined('::firewall') {
    if $configure_firewall == undef {
      fail('The firewall module is included in your manifests, please configure $configure_firewall in the sonarqube module')
    } elsif $configure_firewall {
      include sonarqube::firewall
    }
  }

}
