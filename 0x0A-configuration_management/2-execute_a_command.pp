# Using Puppet to kill a process named killmenow
exec{'killing killmenow process':
  command => '/bin/sh -c "pkill killmenow"',
  path    => ['/usr/bin', '/usr' ],
}
