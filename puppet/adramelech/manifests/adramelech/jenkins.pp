class jenkins::packages {

    user { 'jenkins':
        ensure => 'present',
        shell => '/bin/bash',
        home => "/opt/jenkins",
        managehome => true,
        groups => ['root'],
    }

    file { '/opt/jenkins':
        ensure => 'directory',
        owner => 'jenkins',
        mode => '755',
        require => User['jenkins'],
    }

    file { '/opt/jenkins/jenkins.war':
        mode => 644,
        source => 'puppet:///adramelech_files/jenkins.war',
        require => File['/opt/jenkins'],
    }

    file { '/opt/jre-7u25-linux-i586.tar.gz':
        mode => 644,
        source => 'puppet:///adramelech_files/jre-7u25-linux-i586.tar.gz',
    }

    exec { 'extract_jre':
        command => 'tar xf jre-7u25-linux-i586.tar.gz',
        cwd => '/opt',
        path => '/bin',
        creates => '/opt/jre1.7.0_25/README',
        require => File['/opt/jre-7u25-linux-i586.tar.gz'],
    }

    supervisor::service { 'jenkins':
        ensure      => present,
        enable      => true,
        command     => '/opt/jre1.7.0_25/bin/java -jar /opt/jenkins/jenkins.war',
        directory   => '/opt/jenkins',
        user        => 'jenkins',
        group       => 'jenkins',
        stopsignal  => 'TERM',
        numprocs    => 1,
        require => [Exec['extract_jre'], File['/opt/jenkins/jenkins.war']],
    }

}
