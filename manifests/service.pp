# Class: sonarqube::service
#
# This module manages sonarqube service
#
class sonarqube::service {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  service { 'sonar':
    ensure     => $sonarqube::service_ensure,
    enable     => $sonarqube::service_enable,
    provider   => $sonarqube::service_provider,
    hasstatus  => true,
    hasrestart => true,
  }

}