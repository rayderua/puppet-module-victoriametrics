class victoriametrics::vmalert::config {
  assert_private()

  $_params = deep_merge($::victoriametrics::vmalert::params, { } )

  file { "/etc/default/${::victoriametrics::vmalert::service_name}":
    content => inline_template("ARGS=\"<% @_params.each do | param, value | %> --<%= param -%>=<%= value %> <% end -%>\"\n"),
    notify  => ( true == $::victoriametrics::vmalert::service_restart ) ? {
      true    => Service[$::victoriametrics::vmalert::service_name],
      default => undef
    }
  }
}