class victoriametrics::vmutils::install {
  assert_private()

  if ( 'source' == $::victoriametrics::install_source ) {
    $version = $::victoriametrics::source_version
    $archive_name = $::victoriametrics::install::source::archive_vmutils_name
    $archive_path = $::victoriametrics::install::source::archive_vmutils_path

    $::victoriametrics::vmutils::utils.each | $util | {

      exec { "victoria-${$util}-install":
        user    => 'root',
        path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin', '/usr/local/sbin'],
        command => "tar -xf ${archive_path} -C /tmp ${$util}-prod && mv /tmp/${$util}-prod /usr/bin/${$util}-${version}",
        onlyif  => [ "test ! -f /usr/bin/${$util}-$version"],
        require => Archive['victoria-vmutils'],
      }

      file { "victoria-${$util}-executable":
        ensure  => present,
        path    => "/usr/bin/${$util}-$version",
        owner   => 'root', group => root, mode => '0755',
        require => Exec["victoria-${$util}-install"],
      }

      file { "victoria-${$util}":
        path    => "/usr/bin/${$util}",
        ensure  => 'link',
        target  => "/usr/bin/${$util}-$version",
        owner   => 'root', group => root, mode => '0755',
        require => File["victoria-${$util}-executable"],
      }
    }
  }
}