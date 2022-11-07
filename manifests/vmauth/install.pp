class victoriametrics::vmauth::install {
  assert_private()

  if ( 'source' == $::victoriametrics::install_source ) {
    $version = $::victoriametrics::source_version
    $archive_name = $::victoriametrics::install::source::archive_vmutils_name
    $archive_path = $::victoriametrics::install::source::archive_vmutils_path

    exec { 'victoria-vmauth-install':
      user    => 'root',
      path    =>     ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin'],
      command => "tar -xf ${archive_path} -C /tmp vmauth-prod && mv /tmp/vmauth-prod /usr/bin/vmauth-${version}",
      onlyif  => [ "test ! -f /usr/bin/vmauth-$version"],
      require => Archive['victoria-vmutils'],
    }

    file { 'victoria-vmauth-executable':
      ensure => present,
      path   => "/usr/bin/vmauth-$version",
      owner  => 'root', group => root, mode   => '0755',
      require => Exec['victoria-vmauth-install'],
    }

    file { 'victoria-vmauth':
      path    => '/usr/bin/vmauth',
      ensure  => 'link',
      target  => "/usr/bin/vmauth-$version",
      owner  => 'root', group => root, mode   => '0755',
      before  => File[$::victoriametrics::vmauth::storage_dir],
      require => File['victoria-vmauth-executable'],
      notify  => ( true == $::victoriametrics::vmauth::service_restart ) ? { default => undef, true => Service[$::victoriametrics::vmauth::service_name]}
    }
  }

  file { $::victoriametrics::vmauth::storage_dir:
    ensure  => directory,
    owner   => $::victoriametrics::user,
    group   => $::victoriametrics::group,
    mode    => '0755',
    require => User[$::victoriametrics::user]
  }

  if ( true == $::victoriametrics::vmauth::service_install ) {
    include victoriametrics::systemd_reload

    $user = $::victoriametrics::user
    $service_name = $::victoriametrics::vmauth::service_name
    $storage_dir = $::victoriametrics::vmauth::storage_dir
    file { 'victoriametrics-vmauth.service':
      ensure    => present,
      path      => "/lib/systemd/system/${::victoriametrics::vmauth::service_name}.service",
      content   => template('victoriametrics/victoria-vmauth.service.erb'),
      before    => Service[$::victoriametrics::vmauth::service_name],
      notify    => Exec['victoriametrics-systemd-reload']
    }
  }
}
