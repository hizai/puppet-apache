class apache::params {

  if $lsbdistid == 'AmazonAMI' {
    if $lsbdistrelease =~ /^([0-9]){4}\.([0-9]){2}$/ {
      $year = $1
      $month = $2
    }
  }

  case $lsbdistid {
    /CentOS|RedHat/: { $pkg = 'httpd' }
    /Debian|Ubuntu/: { $pkg = 'apache2'}
    /AmazonAMI/: { if ($year < 2012) or (($year == 2012) and ($month < 09)) { $pkg = 'httpd' } else { $pkg = 'httpd24' } }
  }

  $service = $operatingsystem ? {
    /RedHat|CentOS/ => 'httpd',
    /Linux/ => 'httpd',
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
