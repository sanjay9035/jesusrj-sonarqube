# Class: sonarqube::config
#
# This private class manage manages sonarqube config
#
class sonarqube::config {
  
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  $sonar_properties = '/opt/sonar/conf/sonar.properties'

  # Sonar configuration file
  # Config file content will be replaced by config_properties
  # parameter values
  if $::sonarqube::config_file != undef {
    file { $sonar_properties:
      ensure  => file,
      content => $::sonarqube::config_file,
      owner   => 'sonar',
      group   => 'sonar',
      mode    => '0644',
      require => Package['sonar'],
      notify  => Service['sonar'],
      replace => true,
    }
  }

  # Sonar configuration properties
  if empty($::sonarqube::config_properties) {
    notice('Config properties not provided.')
  } else {
    create_resources( 'sonarqube::propertie', $::sonarqube::config_properties )
  }

}
