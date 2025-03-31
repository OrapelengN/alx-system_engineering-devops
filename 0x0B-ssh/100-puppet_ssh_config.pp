# Configure /etc/ssh/ssh_config for passwordless login.

exec { 'remove_duplicate_identityfile':
  command => "sed -i '/^  IdentityFile/d' /etc/ssh/ssh_config",
  onlyif  => "/bin/grep -c '^  IdentityFile' /etc/ssh/ssh_config | /bin/grep -q '[2-9]'",
  before  => File_line['Declare identity file'],
}

file_line { 'Declare identity file':
  ensure  => present,
  path    => '/etc/ssh/ssh_config',
  line    => '  IdentityFile ~/.ssh/school',
  match   => '^  IdentityFile',
  replace => true,
}

file_line { 'Turn off passwd auth':
  ensure  => present,
  path    => '/etc/ssh/ssh_config',
  line    => 'PasswordAuthentication no',
  match   => '^PasswordAuthentication no$',
  replace => true,
}

file { '/etc/ssh/ssh_config':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  require => [
    File_line['Declare identity file'],
    File_line['Turn off passwd auth'],
  ],
}
