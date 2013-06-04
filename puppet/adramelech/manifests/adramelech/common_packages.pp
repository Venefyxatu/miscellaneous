class common::packages {

    class { apache:
        default_vhost  => false,
        default_ssl_vhost => false,
    }

    portage::package { 'www-servers/apache':
        ensure => 'latest',
        use => ['apache2_modules_php'],
    }

    portage::package { 'dev-lang/php':
        ensure => 'latest',
        use => ['mysql', 'apache2', 'cli', 'sqlite'],
    }

    file { '/usr/lib64/apache2/modules/mod_php5.so':
        ensure => 'link',
        target => '/usr/lib64/apache2/modules/libphp5.so',
        require => Portage::Package['dev-lang/php'],
    }
}
