# configures path to ssh key in ssh_config
file { '/etc/ssh/ssh_config':
  ensure  => present,
  content => "Host *\n    IdentityFile ~/.ssh/school\n    PasswordAuthentication no\n",
}

