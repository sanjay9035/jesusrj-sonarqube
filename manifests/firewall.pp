#
# jenkins::firewall class integrates with the puppetlabs-firewall module for
# opening the port to Jenkins automatically
#
class jenkins::firewall {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  firewall { '500 allow Sonar inbound traffic':
    action => 'accept',
    state  => 'NEW',
    dport  => [$sonarqube::port],
    proto  => 'tcp',
  }

}
