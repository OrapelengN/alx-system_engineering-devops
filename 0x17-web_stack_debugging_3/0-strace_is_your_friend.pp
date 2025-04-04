# 0-strace_is_your_friend.pp
# Create /var/www directory
file { '/var/www':
  ensure => directory,
}

file { '/root/alx-system_engineering-devops/0x17-web_stack_debugging_3/templates':
  ensure => directory,
}

file { '/root/alx-system_engineering-devops/0x17-web_stack_debugging_3/templates/0-strace_is_your_friend':
  ensure  => directory,
  require => File['/root/alx-system_engineering-devops/0x17-web_stack_debugging_3/templates'],
}

# Correct package names and ensure mysql-server is installed.
package { 'mysql-server':
  ensure => installed,
}

package { 'php5-fpm':
  ensure => installed,
}

package { 'php5-mysql':
  ensure => installed,
}

# Create /var/www/html
file { '/var/www/html/':
  ensure  => directory,
  require => File['/var/www'], # Make sure /var/www is created first.
}

package { ['wget', 'tar']:
  ensure => installed,
}

exec { 'download_wordpress':
  command => '/usr/bin/wget https://wordpress.org/latest.tar.gz',
  cwd     => '/var/www/html/',
  creates => '/var/www/html/latest.tar.gz',
  require => File['/var/www/html/'],
}

exec { 'extract_wordpress':
  command => '/bin/tar -xzf latest.tar.gz',
  cwd     => '/var/www/html/',
  require => Exec['download_wordpress'],
  unless  => '/bin/test -d /var/www/html/wp-admin',
}

exec { 'move_wordpress_files':
  command => '/bin/mv /var/www/html/wordpress/* /var/www/html/ && /bin/rm -rf /var/www/html/wordpress',
  require => Exec['extract_wordpress'],
}

file { '/var/www/html/wp-config.php':
  content => template('/root/alx-system_engineering-devops/0x17-web_stack_debugging_3/templates/0-strace_is_your_friend/wp-config.php.erb'),
  require => [Exec['move_wordpress_files'], Package['php5-mysql']],
}

file { '/etc/nginx/sites-available/default':
  content => template('/root/alx-system_engineering-devops/0x17-web_stack_debugging_3/templates/0-strace_is_your_friend/nginx_default.erb'),
  notify  => Service['nginx'],
  require => Package['php5-fpm'], #ensure php-fpm is installed before nginx config is applied.
}

service { 'nginx':
  ensure  => running,
  require => File['/etc/nginx/sites-available/default'], # removed the wp-config.php requirement.
}

exec { 'wordpress_database_setup':
  command => "/usr/bin/mysql -u root -p'Andronicca\\*45' -e 'SHOW DATABASES;'",
  require => Package['mysql-server'],
}

# exec { 'wordpress_database_setup':
#  command => "/usr/bin/mysql -u root -p'Andronicca\\*45' -e 
# \"CREATE DATABASE IF NOT EXISTS wordpress; GRANT ALL PRIVILEGES ON wordpress.* 
# TO \\\"wpuser\\\"@\\\"localhost\\\" IDENTIFIED BY \\\"Andronicca\\*45\\\"; FLUSH PRIVILEGES;\"",
#  require => Package['mysql-server'],
#  unless  => "/usr/bin/mysql -u root -p'Andronicca\\*45' -e \"SHOW DATABASES LIKE \\\"wordpress\\\"\" | /bin/grep wordpress",
# }

service { 'php5-fpm':
  ensure  => running,
  require => Package['php5-fpm'],
}
