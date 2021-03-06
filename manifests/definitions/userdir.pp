define apache::userdirinstance ($ensure=present, $vhost) {

  include apache::params

  file { "${apache::params::root}/${vhost}/conf/userdir.conf":
    ensure => $ensure,
    source => 'puppet:///apache/userdir.conf',
    seltype => $operatingsystem ? {
      "RedHat" => "httpd_config_t",
      "CentOS" => "httpd_config_t",
      "Amazon" => "httpd_config_t",
      "Linux" => "httpd_config_t",
      default  => undef,
    },
    notify => Exec["apache-graceful"],
  }
}
