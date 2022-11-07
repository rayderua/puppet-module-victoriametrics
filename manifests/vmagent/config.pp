class victoriametrics::vmagent::config {
  assert_private()

  $_params = deep_merge($::victoriametrics::vmagent::params, { } )

  file { "/etc/default/${::victoriametrics::vmagent::service_name}":
    content => inline_template("ARGS=\"<% @_params.each do | param, value | %> --<%= param -%>=<%= value %> <% end -%>\"\n"),
    notify  => ( true == $::victoriametrics::vmagent::service_restart ) ? {
      true    => Service[$::victoriametrics::vmagent::service_name],
      default => undef
    }
  }
}