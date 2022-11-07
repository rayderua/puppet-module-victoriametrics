class victoriametrics::vmagent (
  # Configure
  Hash $params                                = {
    'remoteWrite.url' => 'http://127.0.0.1:8428/api/v1/write'
    # '--promscrape.config=/etc/victoria-vmagent/prometheus.yml'
    # - '--memory.allowedPercent=80'
    # - '-promscrape.streamParse=true'
  },
  String $storage_dir                         = '/var/lib/victoria-vmagent',
  # Service
  Boolean $service_install                    = true,
  String $service_name                        = 'victoria-vmagent',
  Enum['stopped', 'running'] $service_ensure  = 'running',
  Boolean $service_enable                     = true,
  Boolean $service_restart                    = true,
){

  contain victoriametrics
  contain victoriametrics::vmagent::install
  contain victoriametrics::vmagent::config
  contain victoriametrics::vmagent::service

  Class['victoriametrics']
  -> Class['victoriametrics::vmagent::install']
  -> Class['victoriametrics::vmagent::config']
  -> Class['victoriametrics::vmagent::service']
}
