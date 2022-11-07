class victoriametrics::vmauth::config {
  assert_private()

  $_params = deep_merge($::victoriametrics::vmauth::params, { 'auth.config' => '/etc/victoria-metrics/vmauth.yml' } )

  file { "/etc/default/${::victoriametrics::vmauth::service_name}":
    content => inline_template("ARGS=\"<% @_params.each do | param, value | %> --<%= param -%>=<%= value %> <% end -%>\"\n"),
    notify  => ( true == $::victoriametrics::vmauth::service_restart ) ? {
      true    => Service[$::victoriametrics::vmauth::service_name],
      default => undef
    },
  }

  $config = $::victoriametrics::vmauth::config

  file { "/etc/victoria-metrics/vmauth.yml":
    owner   => $::victoriametrics::user,
    group   => $::victoriametrics::group,
    mode    => '0755',
    content => inline_template('<%= @config.to_yaml %>'),
    notify  => ( true == $::victoriametrics::vmauth::service_restart ) ? {
      true    => Service[$::victoriametrics::vmauth::service_name],
      default => undef
    },
    require => File[$::victoriametrics::config_dir]
  }

}