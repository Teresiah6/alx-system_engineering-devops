# Fix Apache 500 error, automate using puppet.
# Use exec resource type to run strace
exec { 'attach_strace':
  command => 'strace -p $(pidof apache2) -s 1024 -o /var/log/apache.strace',
  onlyif  => 'pgrep apache2',
}

# Use file resource type to ensure that the strace log file exists
file { '/var/log/apache.strace':
  ensure => 'present',
  mode   => '0644',
}

# Use exec resource type to run a script that parses the strace output and fixes the issue
exec { 'parse_strace':
  command => '/usr/local/bin/parse_strace.sh',
  require => [
    File['/var/log/apache.strace'],
    Package['apache2'],
  ],
  notify  => Service['apache2'],
}

# Use file resource type to ensure that the Apache configuration files are updated
file { '/etc/apache2/httpd.conf':
  ensure => 'present',
  source => 'puppet:///modules/myapp/httpd.conf',
  mode   => '0644',
}

# Use service resource type to ensure that the Apache service is restarted
service { 'apache2':
  ensure => 'running',
  enable => true,
  require => [
    File['/etc/apache2/httpd.conf'],
    Exec['parse_strace'],
  ],
}
