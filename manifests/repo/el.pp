# Class: sonarqube::repo::el
#
class sonarqube::repo::el
{

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  yumrepo { 'sonarqube':
    baseurl  => 'http://downloads.sourceforge.net/project/sonar-pkg/rpm',
    descr    => 'Sonarqube repository',
    enabled  => 1,
    gpgcheck => 0,
  }

}
