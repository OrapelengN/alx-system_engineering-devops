# 0-strace_is_your_friend.pp
file { '/var/www/html/':
  ensure => directory,
}

package { ['wget', 'tar']:
  ensure => installed,
}

exec { 'download_wordpress':
  command => 'wget https://wordpress.org/latest.tar.gz',
  cwd     => '/var/www/html/',
  creates => '/var/www/html/latest.tar.gz',
  require => File['/var/www/html/'],
}

exec { 'extract_wordpress':
  command => 'tar -xzf latest.tar.gz',
  cwd     => '/var/www/html/',
  require => Exec['download_wordpress'],
}

exec { 'move_wordpress_files':
  command => 'mv /var/www/html/wordpress/* /var/www/html/ && rm -rf /var/www/html/wordpress',
  require => Exec['extract_wordpress'],
}

file { '/var/www/html/wp-config.php':
  content => template('/root/alx-system_engineering-devops/0x17-web_stack_debugging_3/templates/0-strace_is_your_friend/wp-config.php.erb'),
  require => Exec['move_wordpress_files'],
}

file { '/etc/nginx/sites-available/default':
  content => template('/root/alx-system_engineering-devops/0x17-web_stack_debugging_3/templates/0-strace_is_your_friend/nginx_default.erb'),
  notify  => Service['nginx'],
}

service { 'nginx':
  ensure  => running,
  require => File['/etc/nginx/sites-available/default'], # removed the wp-config.php requirement.
}

exec { 'wordpress_database_setup':
  command => "mysql -u root -e 'CREATE DATABASE IF NOT EXISTS wordpress; " +
  "GRANT ALL PRIVILEGES ON wordpress.* TO \"wpuser\"@\"localhost\" " +
  "IDENTIFIED BY \"your_password\"; FLUSH PRIVILEGES;'",
  require => Package['mysql-server'],
}

package { 'mysql-server':
  ensure => installed,
}

package { 'php-mysql':
  ensure => installed,
}

service { 'php7.4-fpm':
  ensure  => running,
  require => Package['php-fpm'],
}

package { 'php-fpm':
  ensure => installed,
}
