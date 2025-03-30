# 1-install_a_package.pp
# This manifest installs Flask 2.1.0 and Werkzeug 2.1.0 using pip3 and creates a script to output only the Flask version.

package { 'Werkzeug==2.1.0':
  ensure   => 'installed',
  provider => pip3,
}

package { 'Flask==2.1.0':
  ensure   => 'installed',
  provider => pip3,
  require  => Package['Werkzeug==2.1.0'],
}
