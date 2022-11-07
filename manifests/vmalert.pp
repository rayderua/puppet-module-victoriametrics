class victoriametrics::vmalert (
  # Configure
  Hash $params                                = {
    'datasource.url'  => 'http://127.0.0.1:8428/',
    'remoteWrite.url' => 'http://127.0.0.1:8428/',
    'notifier.url'    => 'http://127.0.0.1:9093/',
  },
  String $storage_dir                         = '/var/lib/victoria-vmalert',
  # Service
  Boolean $service_install                    = true,
  String $service_name                        = 'victoria-vmalert',
  Enum['stopped', 'running'] $service_ensure  = 'running',
  Boolean $service_enable                     = true,
  Boolean $service_restart                    = true,
){

  contain victoriametrics::vmalert::install
  contain victoriametrics::vmalert::config
  contain victoriametrics::vmalert::service

  Class['victoriametrics']
  -> Class['victoriametrics::vmalert::install']
  -> Class['victoriametrics::vmalert::config']
  -> Class['victoriametrics::vmalert::service']
}
