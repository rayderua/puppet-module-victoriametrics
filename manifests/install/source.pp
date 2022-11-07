class victoriametrics::install::source {
  assert_private()

  $archive_metrics_name = "victoria-metrics-linux-amd64-v${::victoriametrics::source_version}.tar.gz"
  $archive_metrics_path = "/usr/local/src/${archive_metrics_name}"
  $archive_metrics_url = "https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/v${::victoriametrics::source_version}/${archive_metrics_name}"

  $archive_vmutils_name = "vmutils-linux-amd64-v${::victoriametrics::source_version}.tar.gz"
  $archive_vmutils_path = "/usr/local/src/${archive_vmutils_name}"
  $archive_vmutils_url = "https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/v${::victoriametrics::source_version}/${archive_vmutils_name}"

  archive{'victoria-metrics':
    path            => $archive_metrics_path,
    ensure          => present,
    source          => $archive_metrics_url,
    checksum        => $::victoriametrics::source_metrics_checksum,
    checksum_type   => $::victoriametrics::source_checksum_type,
  }

  archive{'victoria-vmutils':
    path            => $archive_vmutils_path,
    ensure          => present,
    source          => $archive_vmutils_url,
    checksum        => $::victoriametrics::source_vmutils_checksum,
    checksum_type   => $::victoriametrics::source_checksum_type,
  }
}
