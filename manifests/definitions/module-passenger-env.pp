/*

== Definition: apache::module-passenger-env

Creates a wrapper script to set environment variables for ruby interpreter when
used in a Passenger application


Parameters:
- *template*: path to the ERB template.
- *file*: puppet url to the wrapper script
- *ruby_path*: path to ruby binary we want to use.

Example usage:

  include apache

  apache::module-passenger-env { "optimized-gc":
    template => "fcb/opt/ruby-enterprise/bin/ruby-passenger.erb",
  }

*/

define apache::module-passenger-env($template=false,
                         $file=false,
                         $ruby_path="/opt/ruby-enterprise/bin") {

  if $template != false {
    file { "${ruby_path}/ruby-passenger":
      ensure => file,
      content => template($template),
      owner => 'root',
      group => 'root',
      mode => "0755",
      notify => Exec['apache-graceful']
    }
  }
  elsif $file != false {
    file { "${ruby_path}/ruby-passenger":
      ensure => file,
      source => $file,
      owner => 'root',
      group => 'root',
      mode => "0755",
      notify => Exec['apache-graceful']
    }
  }

  exec { 'change-ruby-passenger':
    command => "sed -i s%$(grep PassengerRuby /etc/httpd/mods-available/passenger.load | awk '{print \$2}')%${ruby_path}/ruby-passenger% /etc/httpd/mods-available/passenger.load",
    path => "/usr/local/bin:/bin:/usr/bin",
    unless => [
      "[ ! -f /etc/httpd/mods-available/passenger.load ]",
      "grep -q '${ruby_path}/ruby-passenger$' /etc/httpd/mods-available/passenger.load",
    ]
  }

}
