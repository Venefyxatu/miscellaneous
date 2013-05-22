class common::packages {

    class { apache:
        default_vhost  => false,
        default_ssl_vhost => false,
    }

    portage::package { 'www-servers/apache':
        ensure => 'latest',
        use => ['apache2_modules_php'],
    }
}
