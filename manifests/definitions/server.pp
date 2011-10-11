define apache::server ($config_template = "apache/httpd.conf.erb",
                       $mpm = "worker",
                       $startservers = "4",
                       $maxclients = "300",
                       $minspare = "25",
                       $maxspare = "75",
                       $threadschild = "25",
                       $maxrequestschild = "0",
                       $serverlimit = "256",
                       $keepalive = "On",
                       $keepaliverequests = "100",
                       $keepalivetimeout = "1"
                        ) {

  include apache::params

  if $mpm == 'worker' {
    exec { "uncomment worker":
      command => "sed -i s/\\#HTTPD=/HTTPD=/ /etc/sysconfig/httpd",
      path => "/usr/local/bin:/bin:/usr/bin",
      onlyif => "[ -s /etc/sysconfig/httpd ] && grep \\#HTTPD= /etc/sysconfig/httpd",
      notify => Exec["apache_restart"], 
    }
  }
  elsif $mpm == 'prefork' {
    exec { "comment worker":
      command => "sed -i s/HTTPD=/\\#HTTPD=/ /etc/sysconfig/httpd",
      path => "/usr/local/bin:/bin:/usr/bin",
      onlyif => "[ -s /etc/sysconfig/httpd ] && cat /etc/sysconfig/httpd | grep ^HTTPD=",
      notify => Exec["apache_restart"], 
    }
  }

  File <| title == "${apache::params::conf}/conf/httpd.conf" |> {
    content => template("${config_template}"),
  }
  
  exec { "apache_restart":
    command => "/etc/init.d/${apache::params::pkg} restart",
    refreshonly => true
  }

}

