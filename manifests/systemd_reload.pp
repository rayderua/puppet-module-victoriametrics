class victoriametrics::systemd_reload {
  exec { 'victoriametrics-systemd-reload':
    path        => ['/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/'],
    command     => 'systemctl daemon-reload',
    refreshonly => true,
  }
}
