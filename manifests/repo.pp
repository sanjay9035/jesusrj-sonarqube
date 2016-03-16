#
# sonarqube::repo handles pulling in the platform specific repo classes
#
class sonarqube::repo {
  include stdlib
  
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }
  
  case $::osfamily {
    'RedHat', 'Linux': {
      class { 'sonarqube::repo::el': }
    }
    'Debian': {
      class { 'sonarqube::repo::debian': }
    }
    default: {
      fail( "Unsupported OS family: ${::osfamily}" )
    }
  }
  
}
