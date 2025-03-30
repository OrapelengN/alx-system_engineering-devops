# 0-create_a_file.pp
# This Puppet manifest creates a file /tmp/school with specific permissions, ownership, and content.

file { '/tmp/school':
  ensure  => present,
  mode    => '0744',
  owner   => 'www-data',
  group   => 'www-data',
  content => 'I love Puppet\n', # Include a newline character at the end
}
