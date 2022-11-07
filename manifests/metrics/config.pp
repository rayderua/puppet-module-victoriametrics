class victoriametrics::metrics::config {
  assert_private()

  $_params = deep_merge($::victoriametrics::metrics::params, { 'storageDataPath' => $::victoriametrics::metrics::storage_dir } )

  file { "/etc/default/${::victoriametrics::metrics::service_name}":
    content => inline_template("ARGS=\"<% @_params.each do | param, value | %> --<%= param -%>=<%= value %> <% end -%>\"\n"),
    notify  => ( true == $::victoriametrics::metrics::service_restart ) ? {
      true    => Service[$::victoriametrics::metrics::service_name],
      default => undef
    }
  }
}