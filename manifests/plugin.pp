define sonarqube::plugin (
  $version,
  $ensure     = present,
  $artifactid = $name,
  $groupid    = 'org.codehaus.sonar-plugins',
  $url        = undef,
) {
  $plugin_name = "${artifactid}-${version}.jar"
  $plugin      = "${sonarqube::plugin_home}/${plugin_name}"

  # Install plugin
  if $ensure == present {

    if $url {
      archive { "/tmp/${plugin_name}":
        ensure => present,
        source => "${url}/${name}/${plugin_name}",
      }
    } else {
      sonar_plugin { "/tmp/${plugin_name}":
        ensure     => $ensure,
        groupid    => $groupid,
        artifactid => $artifactid,
        version    => $version,
        before     => File[$plugin],
        require    => File[$sonarqube::plugin_home],
        notify     => Exec["clean-old-versions-${artifactid}"],
      }
    }

    exec { "clean-old-versions-${artifactid}":
      path        => $::path,
      command     => "find ${sonarqube::plugin_home} -type f \\( -iname '${artifactid}-*.jar' ! -name '${plugin_name}' \\) -delete",
      refreshonly => true,
    }

    file { $plugin:
      ensure  => $ensure,
      source  => "/tmp/${plugin_name}",
      owner   => 'sonar',
      group   => 'sonar',
      notify  => Service['sonar'],
      require => Exec["clean-old-versions-${artifactid}"],
    }
  } else {
    # Uninstall plugin if absent
    file { $plugin:
      ensure => $ensure,
      notify => Service['sonar'],
    }
  }
}
