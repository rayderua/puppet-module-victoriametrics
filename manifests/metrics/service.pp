class victoriametrics::metrics::service {
  assert_private()

  service { $::victoriametrics::metrics::service_name:
    ensure  => $::victoriametrics::metrics::service_ensure,
    enable  => $::victoriametrics::metrics::service_enable,
  }
}