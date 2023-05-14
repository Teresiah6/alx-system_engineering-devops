# Fix Apache 500 error, automate using puppet.
exec { 'attach_strace':
  command => '/usr/bin/strace -p $(pidof apache2) -s 1024 -o /var/log/apache.strace',
  onlyif  => '/usr/bin/pgrep apache2 > /dev/null',
refreshonly => true,
}

