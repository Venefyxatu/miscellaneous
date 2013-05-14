
class phenny::packages {

    portage::package { 'dev-python/meld3':
        ensure => 'latest',
        keywords => '~amd64',
    }
    portage::package { 'app-admin/supervisor':
        ensure => 'latest',
        keywords => '~amd64',
        require => Portage::Package['dev-python/meld3'],
    }

    portage::package { 'www-servers/apache':
        ensure => 'latest',
        use => ['apache2_modules_php'],
    }

    portage::package { 'www-apache/mod_wsgi':
        ensure => 'latest',
        require => Portage::Package['www-servers/apache'],
    }

    portage::package { 'dev-python/virtualenvwrapper':
        ensure => 'latest',
        keywords => '~amd64',
    }

    python::virtualenv { '/home/erik/.virtualenvs/phenny':
        ensure => 'present',
    }

    python::pip { 'Django==1.4.2':
        ensure => 'present',
        virtualenv => '/home/erik/.virtualenvs/phenny',
    }

    python::pip { 'MySQL-python':
        ensure => 'present',
        virtualenv => '/home/erik/.virtualenvs/phenny',
    }

    python::pip { 'South==0.7.6':
        ensure => 'present',
        virtualenv => '/home/erik/.virtualenvs/phenny',
    }

    python::pip { 'coverage':
        ensure => 'latest',
        virtualenv => '/home/erik/.virtualenvs/phenny',
    }

    python::pip { 'django-tables==0.2':
        ensure => 'present',
        virtualenv => '/home/erik/.virtualenvs/phenny',
    }

    python::pip { 'ipython':
        ensure => 'latest',
        virtualenv => '/home/erik/.virtualenvs/phenny',
    }

    python::pip { 'nose':
        ensure => 'latest',
        virtualenv => '/home/erik/.virtualenvs/phenny',
    }

    python::pip { 'requests==1.1.0':
        ensure => 'present',
        virtualenv => '/home/erik/.virtualenvs/phenny',
    }

    python::pip { 'wsgiref':
        ensure => 'present',
        virtualenv => '/home/erik/.virtualenvs/phenny',
    }

}
    
class phenny::configuration {
    require phenny::packages

    a2mod { 'wsgi': 
        ensure => 'present',
    }

    
    apache::vhost { 'phenny.venefyxatu.be':
        port => 80,
        docroot => '/var/www/venefyxatu.be/phenny/phennyfyxata/apache',
        mediaroot => '/var/www/venefyxatu.be/phenny/phennyfyxata/media/scores/',
        vhost_name => '*',
        serveradmin => 'venefyxatu@gmail.com',
        servername => 'phenny.venefyxatu.be',
        serveraliases => ['adramelech.venefyxatu.be'],
        wsgi_script => '/var/www/venefyxatu.be/phenny/phennyfyxata/apache/django.wsgi',
        wsgi_python_home => '/home/erik/.virtualenvs/phenny/',
        options => '',
        override => 'All',
        priority => 10,
        template => 'phenny/phenny-vhost.erb',
        configure_firewall => false,
    }

    mysql::db { 'phenny_scores':
      user     => 'django',
      password => 'PHENNY_SCORES_PASSWORD',
      host     => 'localhost',
      grant    => ['all'],
    }

    file { '/opt/projects':
        ensure => 'directory',
        owner => 'erik',
        group => 'erik',
    }

    git::repo { 'phennyfyxata-apache':
      path => '/var/www/venefyxatu.be/phenny',
      source => 'https://github.com/Venefyxatu/phennyfyxata.git',
      owner => 'apache',
      update => true,
    }

    git::repo { 'phennyfyxata':
      path => '/home/erik/source/phennyfyxata',
      source => 'https://github.com/Venefyxatu/phennyfyxata.git',
      owner => 'erik',
      update => true,
    }

    git::repo { 'phenny_palmersbot':
      path => '/opt/projects/phenny',
      source => 'https://github.com/Venefyxatu/phenny.git',
      owner => 'erik',
      update => false,
      require => File['/opt/projects'],
    }

    git::repo { 'evilphenny':
      path => '/opt/projects/evilphenny',
      source => 'https://github.com/Venefyxatu/phenny.git',
      owner => 'erik',
      update => false,
      require => File['/opt/projects'],
    }

    file { '/opt/projects/evilphenny/modules/roulette.py':
        ensure => 'link',
        target => '/var/www/venefyxatu.be/phenny/phenny/roulette.py',
        owner => 'erik',
        group => 'erik',
        require => Git::Repo['phennyfyxata-apache', 'evilphenny']
    }

    file { '/opt/projects/phenny/modules/hoichat.py':
        ensure => 'link',
        target => '/var/www/venefyxatu.be/phenny/phenny/hoichat.py',
        owner => 'erik',
        group => 'erik',
        require => Git::Repo['phennyfyxata-apache', 'phenny_palmersbot']
    }

    file { '/opt/projects/phenny/modules/nanowars.py':
        ensure => 'link',
        target => '/var/www/venefyxatu.be/phenny/phenny/nanowars.py',
        owner => 'erik',
        group => 'erik',
        require => Git::Repo['phennyfyxata-apache', 'phenny_palmersbot']
    }

    file { '/var/www/venefyxatu.be':
        ensure => 'directory',
        owner => 'apache',
        group => 'apache',
    }

    file { '/opt/projects/phenny/modules/help.py':
        ensure => 'link',
        target => '/var/www/venefyxatu.be/phenny/phenny/help.py',
        owner => 'erik',
        group => 'erik',
        require => Git::Repo['phennyfyxata-apache', 'phenny_palmersbot']
    }

    file { '/opt/projects/evilphenny/modules/lart.py':
        ensure => 'link',
        target => '/var/www/venefyxatu.be/phenny/phenny/lart.py',
        owner => 'erik',
        group => 'erik',
        require => Git::Repo['phennyfyxata-apache', 'evilphenny']
    }

    file { '/opt/projects/evilphenny/lartstore.txt':
        ensure => 'link',
        target => '/var/www/venefyxatu.be/phenny/phenny/lartstore.txt',
        owner => 'erik',
        group => 'erik',
        require => Git::Repo['phennyfyxata-apache', 'evilphenny']
    }

    file { '/home/erik/.phenny':
        ensure => 'link',
        target => '/home/erik/source/phennyfyxata/.phenny',
        owner => 'erik',
        group => 'erik',
        require => Git::Repo['phennyfyxata']
    }

    exec { "/bin/sed -i 's/PLACEHOLDER_PASSWORD/IRC_PASSWORD/' /home/erik/.phenny/*py":
        path => '/usr/bin',
        require => File['/home/erik/.phenny']
    }

    exec { "/bin/sed -i 's/PUPPET__PHENNY__SCORES__PASSWORD/PHENNY_SCORES_PASSWORD/' /var/www/venefyxatu.be/phenny/phennyfyxata/settings.py":
        path => '/usr/bin',
        require => Git::Repo['phennyfyxata-apache']
    }



}

class phenny::bots { 
    require phenny::configuration

    class { 'supervisor':
        enable_inet_server => true,
        inet_server_port => '0.0.0.0:9001',
        inet_server_user => 'master',
        inet_server_pass => 'SUPERVISOR_PASSWORD',
        logfile_maxbytes => '100MB',
    }

    supervisor::service { 'phenny':
        ensure      => present,
        enable      => true,
        command     => '/usr/bin/pidproxy /home/erik/.phenny/phenny.default.pid /opt/projects/phenny/phenny',
        environment => "PYTHONPATH='/home/erik/.virtualenvs/phenny/lib/python2.7/site-packages/setuptools-0.6c11-py2.7.egg:/usr/lib/portage/pym:/home/erik/.virtualenvs/phenny/lib64/python27.zip:/home/erik/.virtualenvs/phenny/lib64/python2.7:/home/erik/.virtualenvs/phenny/lib64/python2.7/plat-linux2:/home/erik/.virtualenvs/phenny/lib64/python2.7/lib-tk:/home/erik/.virtualenvs/phenny/lib64/python2.7/lib-old:/home/erik/.virtualenvs/phenny/lib64/python2.7/lib-dynload:/usr/lib/python2.7:/usr/lib64/python2.7:/usr/lib/python2.7/plat-linux2:/home/erik/.virtualenvs/phenny/lib/python2.7/site-packages:/home/erik/.virtualenvs/phenny/lib/python2.7/site-packages/setuptools-0.6c11-py2.7.egg-info',HOME=/home/erik",
        directory   => '/opt/projects/phenny',
        user        => 'erik',
        group       => 'erik',
        stopsignal  => 'TERM',
        numprocs    => 1,
    }

    supervisor::service { 'evilphenny':
        ensure      => present,
        enable      => true,
        command     => '/usr/bin/pidproxy /home/erik/.phenny/phenny.evil.pid /opt/projects/evilphenny/phenny -c /home/erik/.phenny/evil.py',
        environment => "PYTHONPATH='/home/erik/.virtualenvs/phenny/lib/python2.7/site-packages/setuptools-0.6c11-py2.7.egg:/usr/lib/portage/pym:/home/erik/.virtualenvs/phenny/lib64/python27.zip:/home/erik/.virtualenvs/phenny/lib64/python2.7:/home/erik/.virtualenvs/phenny/lib64/python2.7/plat-linux2:/home/erik/.virtualenvs/phenny/lib64/python2.7/lib-tk:/home/erik/.virtualenvs/phenny/lib64/python2.7/lib-old:/home/erik/.virtualenvs/phenny/lib64/python2.7/lib-dynload:/usr/lib/python2.7:/usr/lib64/python2.7:/usr/lib/python2.7/plat-linux2:/home/erik/.virtualenvs/phenny/lib/python2.7/site-packages:/home/erik/.virtualenvs/phenny/lib/python2.7/site-packages/setuptools-0.6c11-py2.7.egg-info',HOME=/home/erik",
        directory   => '/opt/projects/evilphenny',
        user        => 'erik',
        group       => 'erik',
        stopsignal  => 'TERM',
        numprocs    => 1,
    }

}
