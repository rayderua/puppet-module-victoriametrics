class victoriametrics::metrics (
  # Configure
  Hash $params                                = {},
  String $storage_dir                         = '/var/lib/victoria-metrics',
  # Service
  Boolean $service_install                    = false,
  String $service_name                        = 'victoria-metrics',
  Enum['stopped', 'running'] $service_ensure  = 'running',
  Boolean $service_enable                     = true,
  Boolean $service_restart                    = false,
){

  contain victoriametrics
  contain victoriametrics::metrics::install
  contain victoriametrics::metrics::config
  contain victoriametrics::metrics::service

  Class['victoriametrics']
  -> Class['victoriametrics::metrics::install']
  -> Class['victoriametrics::metrics::config']
  -> Class['victoriametrics::metrics::service']
}
