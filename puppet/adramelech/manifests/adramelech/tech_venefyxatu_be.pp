class tech::configuration {

    file { '/etc/apache2/vhosts.d/20-tech.venefyxatu.be.conf':
        mode => 644,
        source => 'puppet:///adramelech_files/apache/20-tech.venefyxatu.be.conf',
        require => [Exec['extract_tech.venefyxatu.be'], Apache::Mod['rewrite']],
    }

    file { '/etc/ssl/tech':
        ensure => directory,
        source => 'puppet:///adramelech_files/ssl/tech',
        recurse => true,
        purge => false,
    }

    file { '/etc/apache2/vhosts.d/20-tech.venefyxatu.be.443.conf':
        mode => 644,
        source => 'puppet:///adramelech_files/apache/20-tech.venefyxatu.be.443.conf',
        require => [Exec['extract_tech.venefyxatu.be'], Apache::Mod['rewrite'], File['/etc/ssl/tech']],
    }
    
    apache::mod { 'rewrite': }
    apache::mod { 'ssl': }
    apache::mod { 'php5': }

    file { '/var/www/venefyxatu.be/tech.venefyxatu.be.tar.bz2':
        source => 'puppet:///adramelech_files/tech.venefyxatu.be.tar.bz2',
    }

    file { '/var/www/venefyxatu.be/stories.venefyxatu.be.tar.bz2':
        source => 'puppet:///adramelech_files/stories.venefyxatu.be.tar.bz2',
    }

    exec { 'extract_tech.venefyxatu.be':
        command => 'tar xf /var/www/venefyxatu.be/tech.venefyxatu.be.tar.bz2',
        cwd => '/var/www/venefyxatu.be/',
        path => '/bin',
        creates => '/var/www/venefyxatu.be/tech/',
        require => File['/var/www/venefyxatu.be/tech.venefyxatu.be.tar.bz2'],
    }

    exec { 'extract_stories.venefyxatu.be':
        command => 'tar xf /var/www/venefyxatu.be/stories.venefyxatu.be.tar.bz2',
        cwd => '/var/www/venefyxatu.be/',
        path => '/bin',
        creates => '/var/www/venefyxatu.be/stories/',
        require => File['/var/www/venefyxatu.be/stories.venefyxatu.be.tar.bz2'],
    }


}

class tech::database {
    mysql::db { 'blog':
      user     => 'bloggie',
      password => 'BLOGGIE_PASSWORD',
      host     => 'localhost',
      grant    => ['all'],
    }

}
