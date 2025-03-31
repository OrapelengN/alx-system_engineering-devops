$home = $facts['home']

file_line { 'Declare identity file':
  ensure => present,
  path   => "${home}/.ssh/config",
  line   => '  IdentityFile ~/.ssh/school',
  match  => '  IdentityFile',
}

file_line { 'Turn off passwd auth':
  ensure => present,
  path   => "${home}/.ssh/config",
  line   => '  PasswordAuthentication no',
  match  => '  PasswordAuthentication',
}

file { "${home}/.ssh/config" :
  ensure => file,
  owner => 'root',
  group => 'root',
  mode => '0644',
  require => [
    File_line['Declare identity file'],
    File_line['Turn off passwd auth'],
  ]
}

file { "${home}/.ssh":
    ensure => directory,
    owner => 'root',
    group => 'root',
    mode => '0700',
}
