# Class: sonarqube::repo::debian
#
class sonarqube::repo::debian
{
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  include stdlib
  include apt

  apt::source { 'sonarqube':
    location       => 'http://downloads.sourceforge.net/project/sonar-pkg/deb',
    repos          => 'binary/',
    include_src    => false,
    trusted_source => true,
  }

  anchor { 'jenkins::repo::debian::begin': } ->
    Apt::Source['sonarqube'] ->
    anchor { 'jenkins::repo::debian::end': }
}
