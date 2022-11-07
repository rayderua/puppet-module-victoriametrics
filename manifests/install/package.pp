class victoriametrics::install::package {

  package { 'victoriametrics':
    ensure => 'installed',
    name => $::victoriametrics::package_name
  }
}