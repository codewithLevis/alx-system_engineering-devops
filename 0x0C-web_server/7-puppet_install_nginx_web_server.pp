# Install and configure Nginx
class nginx_install {
  package { 'nginx':
    ensure => installed,
  }

  file { '/var/www/html':
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  file { '/var/www':
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  file { '/var/www/html/index.nginx-debian.html':
    ensure  => present,
    content => "Hello world!\n",
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0644',
  }

  file { '/var/www/html/error_404.html':
    ensure  => present,
    content => "Ceci n'est pas une page\n",
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0644',
  }

  file { '/etc/nginx/sites-available/default':
    ensure  => present,
    content => "
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;
    error_page 404 /error_404.html;

    server_name _;

    location / {
        try_files \$uri \$uri/ =404;
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
  }

  service { 'nginx':
    ensure  => running,
    enable  => true,
    require => File['/etc/nginx/sites-available/default'],
  }
}

include nginx_install

