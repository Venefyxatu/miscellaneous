class roleplay::configuration {

    apache::listen { '443': }

    apache::namevirtualhost { '*:443': }

    file { '/etc/apache2/vhosts.d/30-roleplay.venefyxatu.be.conf':
        mode => 644,
        source => 'puppet:///adramelech_files/apache/30-roleplay.venefyxatu.be.conf',
        require => [Exec['extract_roleplay.venefyxatu.be'], Apache::Mod['rewrite']],
    }

    file { '/etc/ssl/roleplay':
        ensure => directory,
        source => 'puppet:///adramelech_files/ssl/roleplay',
        recurse => true,
        purge => false,
    }

    file { '/etc/apache2/vhosts.d/30-roleplay.venefyxatu.be.443.conf':
        mode => 644,
        source => 'puppet:///adramelech_files/apache/30-roleplay.venefyxatu.be.443.conf',
        require => [Exec['extract_roleplay.venefyxatu.be'], Apache::Mod['rewrite'], File['/etc/ssl/roleplay']],
    }
    
    file { '/var/www/venefyxatu.be/roleplay.venefyxatu.be.tar.bz2':
        source => 'puppet:///adramelech_files/roleplay.venefyxatu.be.tar.bz2',
    }

    exec { 'extract_roleplay.venefyxatu.be':
        command => 'tar xf /var/www/venefyxatu.be/roleplay.venefyxatu.be.tar.bz2',
        cwd => '/var/www/venefyxatu.be/',
        path => '/bin',
        creates => '/var/www/venefyxatu.be/roleplay/',
        require => File['/var/www/venefyxatu.be/roleplay.venefyxatu.be.tar.bz2'],
    }

}

class roleplay::database {
    mysql::db { 'profiler':
      user     => 'rpgprofiler',
      password => 'PROFILER_PASSWORD',
      host     => 'localhost',
      grant    => ['all'],
    }

}
