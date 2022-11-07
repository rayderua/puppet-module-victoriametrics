class victoriametrics::vmutils (
  $utils = ['vmbackup', 'vmrestore', 'vmctl' ]
){

  contain victoriametrics::vmutils::install

  Class['victoriametrics']
  -> Class['victoriametrics::vmutils::install']
}
