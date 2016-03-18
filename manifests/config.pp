# Class: sonarqube::config
#
# This private class manage manages sonarqube config
#
class sonarqube::config {
  
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  # Sonar configuration file
  # Config file content will be replaced by config_properties
  # parameter values
  if $::sonarqube::config_file != undef {
    file { $sonarqube::sonar_properties:
      ensure  => file,
      content => $sonarqube::config_file,
      owner   => 'sonar',
      group   => 'sonar',
      mode    => '0644',
      require => Package['sonar'],
      notify  => Service['sonar'],
      replace => true,
    }
  }

  # Sonar configuration properties
  if empty($sonarqube::config_properties) {
    notice('Config properties not provided.')
  } else {
    create_resources( 'sonarqube::propertie', $sonarqube::config_properties )
  }

  # Ensure $sonarqube::plugin_home exist with proper permissions
  file { $sonarqube::plugin_home:
    ensure => directory,
    owner  => 'sonar',
    group  => 'sonar',
    mode   => '0755',
  }

}
