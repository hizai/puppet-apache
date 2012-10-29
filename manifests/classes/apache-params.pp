class apache::params {

  $pkg = $operatingsystem ? {
    /RedHat|CentOS/ => 'httpd',
    /Linux/ => 'httpd24',
    /Debian|Ubuntu/ => 'apache2',
  }

  $root = $apache_root ? {
    "" => $operatingsystem ? {
      /RedHat|CentOS|Amazon|Linux/ => '/var/www/vhosts',
      /Debian|Ubuntu/ => '/var/www',
    },
    default => $apache_root
  }

  $user = $operatingsystem ? {
    /RedHat|CentOS|Amazon|Linux/ => 'apache',
    /Debian|Ubuntu/ => 'www-data',
  }

  $conf = $operatingsystem ? {
    /RedHat|CentOS|Amazon|Linux/ => '/etc/httpd',
    /Debian|Ubuntu/ => '/etc/apache2',
  }

  $cgi = $operatingsystem ? {
    /RedHat|CentOS|Amazon|Linux/ => '/var/www/cgi-bin',
    /Debian|Ubuntu/ => '/usr/lib/cgi-bin',
  }

  $log = $operatingsystem ? {
    /RedHat|CentOS|Amazon|Linux/ => '/var/log/httpd',
    /Debian|Ubuntu/ => '/var/log/apache2',
  }

}
