class victoriametrics::vmauth::service {
  assert_private()

  service { $::victoriametrics::vmauth::service_name:
    ensure  => $::victoriametrics::vmauth::service_ensure,
    enable  => $::victoriametrics::vmauth::service_enable,
  }
}