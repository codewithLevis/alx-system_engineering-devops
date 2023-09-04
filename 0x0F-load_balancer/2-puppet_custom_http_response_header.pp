# Define a Puppet class to manage the installation and configuration of Nginx
class nginx_config {
  
  # Package and service definitions for Nginx
  package { 'nginx':
    ensure => 'installed',
  }

  service { 'nginx':
    ensure    => 'running',
    enable    => true,
    require   => Package['nginx'],
    subscribe => File['/etc/nginx/sites-available/default'],
  }

  # Ensure the directory and its permissions
  file { '/var/www/html':
    ensure  => 'directory',
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0755',
    require => Package['nginx'],
  }

  # Create index and error pages
  file { '/var/www/html/index.nginx-debian.html':
    content => 'Hello world!',
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0644',
    require => File['/var/www/html'],
  }

  file { '/var/www/html/error_404.html':
    content => "Ceci n'est pas une page",
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0644',
    require => File['/var/www/html'],
  }

  # Configure Nginx site
  file { '/etc/nginx/sites-available/default':
    content => "
      server {
        listen 80 default_server;
        listen [::]:80 default_server;
        root /var/www/html;
        index index.html index.htm index.nginx-debian.html;
        add_header X-Served-By $hostname;
        error_page 404 /error_404.html;
        server_name _;

        location / {
          try_files $uri $uri/ =404;
        }

        location ~ /redirect_me {
          return 301 https://www.example.com/;
        }

        location = /error_404.html {
          internal;
        }
      }
    ",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

  # Restart Nginx when the configuration changes
  File['/etc/nginx/sites-available/default'] ~> Service['nginx']
}

# Apply the nginx_config class
include nginx_config
