class victoriametrics::vmalert::install {
  assert_private()

  if ( 'source' == $::victoriametrics::install_source ) {
    $version = $::victoriametrics::source_version
    $archive_name = $::victoriametrics::install::source::archive_vmutils_name
    $archive_path = $::victoriametrics::install::source::archive_vmutils_path

    exec { 'victoria-vmalert-install':
      user    => 'root',
      path    =>     ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin'],
      command => "tar -xf ${archive_path} -C /tmp vmalert-prod && mv /tmp/vmalert-prod /usr/bin/vmalert-${version}",
      onlyif  => [ "test ! -f /usr/bin/vmalert-$version"],
      require => Archive['victoria-vmutils'],
    }

    file { 'victoria-vmalert-executable':
      ensure => present,
      path   => "/usr/bin/vmalert-$version",
      owner  => 'root', group => root, mode   => '0755',
      require => Exec['victoria-vmalert-install'],
    }

    file { 'victoria-vmalert':
      path    => '/usr/bin/vmalert',
      ensure  => 'link',
      target  => "/usr/bin/vmalert-$version",
      owner  => 'root', group => root, mode   => '0755',
      before  => File[$::victoriametrics::vmalert::storage_dir],
      require => File['victoria-vmalert-executable'],
      notify  => ( true == $::victoriametrics::vmalert::service_restart ) ? { default => undef, true => Service[$::victoriametrics::vmalert::service_name]}
    }
  }

  file { $::victoriametrics::vmalert::storage_dir:
    ensure  => directory,
    owner   => $::victoriametrics::user,
    group   => $::victoriametrics::group,
    mode    => '0755',
    require => User[$::victoriametrics::user]
  }

  if ( true == $::victoriametrics::vmalert::service_install ) {
    include victoriametrics::systemd_reload

    $user = $::victoriametrics::user
    $service_name = $::victoriametrics::vmalert::service_name
    $storage_dir = $::victoriametrics::vmalert::storage_dir
    file { 'victoriametrics-vmalert.service':
      ensure    => present,
      path      => "/lib/systemd/system/${::victoriametrics::vmalert::service_name}.service",
      content   => template('victoriametrics/victoria-vmalert.service.erb'),
      before    => Service[$::victoriametrics::vmalert::service_name],
      notify    => Exec['victoriametrics-systemd-reload']
    }
  }
}
