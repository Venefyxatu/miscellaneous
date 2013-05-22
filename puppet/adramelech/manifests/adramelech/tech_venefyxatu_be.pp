class tech::configuration {

    file { '/var/www/venefyxatu.be/tech':
        ensure => 'directory',
    }

    apache::vhost { 'tech.venefyxatu.be':
        port => 80,
        add_listen => false,
        docroot => '/var/www/venefyxatu.be/tech',
        vhost_name => 'tech.venefyxatu.be',
        logroot => '/var/log/apache2',
        serveradmin => 'venefyxatu@gmail.com',
        servername => 'tech.venefyxatu.be',
        serveraliases => ['stories.venefyxatu.be', 'blog.venefyxatu.be'],
        options => '',
        override => 'All',
        priority => 20,
        template => 'apache/vhost.conf.erb',
        configure_firewall => false,
        require => File['/var/www/venefyxatu.be/tech']
    }

}
