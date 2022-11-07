class victoriametrics (
  # Repo options
  Boolean $repo_manage  = $::victoriametrics::params::repo_manage,
  Hash $repo_source     = $::victoriametrics::params::repo_source,
  # Source options
  String $source_version   = '1.83.0',
  String $source_checksum_type = 'md5',
  String $source_metrics_checksum  = 'c7383ff19ae220206b6474fbf41f98fd',
  String $source_vmutils_checksum  = '6cdee0e1d8eb63bfcb5fac6a8f16b57c',


  # Install options
  Enum['source', 'package', 'skip'] $install_source = 'package',
  String $package_name  = $::victoriametrics::params::pacakge_name,

  String $config_dir    = $::victoriametrics::params::config_dir,
  String $user          = $::victoriametrics::params::user,
  String $group         = $::victoriametrics::params::group,

  # Service

  #
) inherits victoriametrics::params {

  if ( true == $repo_manage ) {
    include victoriametrics::repo
    Class['victoriametrics::repo'] -> Class['victoriametrics::install']
  }

  contain victoriametrics::install
}