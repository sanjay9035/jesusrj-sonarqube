# Define sonarqube::propertie
# 
define sonarqube::propertie (
  $value,
) {
  validate_string($value)

  file_line { "Sonar propertie ${name}":
    path  => '/opt/sonar/conf/sonar.properties',
    line  => "${name}=${value}",
    match => "^${name}=",
  }

}