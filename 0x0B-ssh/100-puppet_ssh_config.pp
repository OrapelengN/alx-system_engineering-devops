# Configure /etc/ssh/ssh_config for passwordless login.

file_line { 'Declare identity file':
  ensure => present,
  path   => '/etc/ssh/ssh_config',
  line   => '  IdentityFile ~/.ssh/school',
  match  => '  IdentityFile',
}

file_line { 'Turn off passwd auth':
  ensure => present,
  path   => '/etc/ssh/ssh_config',
  line   => '  PasswordAuthentication no',
  match  => '  PasswordAuthentication',
}

file { '/etc/ssh/ssh_config' :
  ensure => file,
  owner => 'root',
  group => 'root',
  mode => '0644',
  require => [
    File_line['Declare identity file'],
    File_line['Turn off passwd auth'],
  ]
}
