class victoriametrics::install {

  if ( 'package' == $::victoriametrics::install_source ) {
    include victoriametrics::install::package
    Class['victoriametrics::install::package'] -> User[$::victoriametrics::user]
  }

  if ( 'source' == $::victoriametrics::install_source ) {
    include victoriametrics::install::source
  }
  user { $::victoriametrics::user:
    ensure      => 'present',
    system      => true,
    comment     => 'VictoriaMetrics daemon',
    home        => '/var/lib/victoria-metrics',
    shell       => '/usr/sbin/nologin',
    password    => '*'
  }

  file { $::victoriametrics::config_dir:
    ensure  => directory,
    owner   => $::victoriametrics::user,
    group   => $::victoriametrics::group,
    mode    => '0750',
    require => User[$::victoriametrics::user]
  }
}