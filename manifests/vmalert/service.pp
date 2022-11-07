class victoriametrics::vmalert::service {
  assert_private()

  service { $::victoriametrics::vmalert::service_name:
    ensure  => $::victoriametrics::vmalert::service_ensure,
    enable  => $::victoriametrics::vmalert::service_enable,
  }
}