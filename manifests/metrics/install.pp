class victoriametrics::metrics::install {
  assert_private()

  if ( 'source' == $::victoriametrics::install_source ) {
    $version = $::victoriametrics::source_version
    $archive_name = $::victoriametrics::install::source::archive_metrics_name
    $archive_path = $::victoriametrics::install::source::archive_metrics_path

    exec { 'victoria-metrics-install':
      user    => 'root',
      path    =>     ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin'],
      command => "tar -xf ${archive_path} -C /tmp victoria-metrics-prod && mv /tmp/victoria-metrics-prod /usr/bin/victoria-metrics-${version}",
      onlyif  => [ "test ! -f /usr/bin/victoria-metrics-$version"],
      require => Archive['victoria-metrics'],
    }

    file { 'victoria-metrics-executable':
      ensure => present,
      path   => "/usr/bin/victoria-metrics-$version",
      owner  => 'root', group => root, mode   => '0755',
      require => Exec['victoria-metrics-install'],
    }

    file { 'victoria-metrics':
      path    => '/usr/bin/victoria-metrics',
      ensure  => 'link',
      target  => "/usr/bin/victoria-metrics-$version",
      owner  => 'root', group => root, mode   => '0755',
      before  => File[$::victoriametrics::metrics::storage_dir],
      require => File[victoria-metrics-executable],
      notify  => ( true == $::victoriametrics::metrics::service_restart ) ? { default => undef, true => Service[$::victoriametrics::metrics::service_name]}
    }
  }

  file { $::victoriametrics::metrics::storage_dir:
    ensure  => directory,
    owner   => $::victoriametrics::user,
    group   => $::victoriametrics::group,
    mode    => '0755',
    require => User[$::victoriametrics::user]
  }

  if ( true == $::victoriametrics::metrics::service_install ) {
    include victoriametrics::systemd_reload

    $user = $::victoriametrics::user
    $service_name = $::victoriametrics::metrics::service_name

    file { 'victoriametrics-metrics.service':
      ensure    => present,
      path      => "/lib/systemd/system/${::victoriametrics::metrics::service_name}.service",
      content   => template('victoriametrics/victoria-metrics.service.erb'),
      before    => Service[$::victoriametrics::metrics::service_name],
      notify    => ( true == $::victoriametrics::metrics::service_restart ) ? { default => Exec['victoriametrics-systemd-reload'], true => [ Exec['victoriametrics-systemd-reload'], Service[$::victoriametrics::metrics::service_name] ]}
    }
  }
}
