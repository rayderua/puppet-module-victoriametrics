class victoriametrics::vmauth (
  # Configure
  Hash $params                                = {},
  Hash $config                                = { 'users' =>  [
    { 'username' => "local-single-node", 'password' => "password", 'url_prefix' => "http://localhost:8428" }
  ]},
  String $storage_dir                         = '/var/lib/victoria-vmauth',
  # Service
  Boolean $service_install                    = true,
  String $service_name                        = 'victoria-vmauth',
  Enum['stopped', 'running'] $service_ensure  = 'running',
  Boolean $service_enable                     = true,
  Boolean $service_restart                    = true,
){

  contain victoriametrics::vmauth::install
  contain victoriametrics::vmauth::config
  contain victoriametrics::vmauth::service

  Class['victoriametrics']
  -> Class['victoriametrics::vmauth::install']
  -> Class['victoriametrics::vmauth::config']
  -> Class['victoriametrics::vmauth::service']
}
