class victoriametrics::vmagent::service {
  assert_private()

  service { $::victoriametrics::vmagent::service_name:
    ensure  => $::victoriametrics::vmagent::service_ensure,
    enable  => $::victoriametrics::vmagent::service_enable,
  }
}