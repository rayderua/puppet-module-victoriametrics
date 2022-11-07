class victoriametrics::vmagent::install {
  assert_private()

  if ( 'source' == $::victoriametrics::install_source ) {
    $version = $::victoriametrics::source_version
    $archive_name = $::victoriametrics::install::source::archive_vmutils_name
    $archive_path = $::victoriametrics::install::source::archive_vmutils_path

    exec { 'victoria-vmagent-install':
      user    => 'root',
      path    =>     ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin'],
      command => "tar -xf ${archive_path} -C /tmp vmagent-prod && mv /tmp/vmagent-prod /usr/bin/vmagent-${version}",
      onlyif  => [ "test ! -f /usr/bin/vmagent-$version"],
      require => Archive['victoria-vmutils'],
    }

    file { 'victoria-vmagent-executable':
      ensure => present,
      path   => "/usr/bin/vmagent-$version",
      owner  => 'root', group => root, mode   => '0755',
      require => Exec['victoria-metrics-install'],
    }

    file { 'victoria-vmagent':
      path    => '/usr/bin/vmagent',
      ensure  => 'link',
      target  => "/usr/bin/vmagent-$version",
      owner  => 'root', group => root, mode   => '0755',
      before  => File[$::victoriametrics::vmagent::storage_dir],
      require => File['victoria-vmagent-executable'],
      notify  => ( true == $::victoriametrics::vmagent::service_restart ) ? { default => undef, true => Service[$::victoriametrics::vmagent::service_name]}
    }
  }

  file { $::victoriametrics::vmagent::storage_dir:
    ensure  => directory,
    owner   => $::victoriametrics::user,
    group   => $::victoriametrics::group,
    mode    => '0755',
    require => User[$::victoriametrics::user]
  }

  if ( true == $::victoriametrics::vmagent::service_install ) {
    include victoriametrics::systemd_reload

    $user = $::victoriametrics::user
    $service_name = $::victoriametrics::vmagent::service_name
    $storage_dir = $::victoriametrics::vmagent::storage_dir
    file { 'victoriametrics-vmagent.service':
      ensure    => present,
      path      => "/lib/systemd/system/${::victoriametrics::vmagent::service_name}.service",
      content   => template('victoriametrics/victoria-vmagent.service.erb'),
      before    => Service[$::victoriametrics::vmagent::service_name],
      notify    => Exec['victoriametrics-systemd-reload']
    }
  }
}
