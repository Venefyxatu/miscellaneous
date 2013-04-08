
class phenny::packages {
    package { 'python-virtualenvwrapper':
        ensure => 'latest',
    }

    python::virtualenv { '/projects/erik/virtualenvs/phenny':
        ensure => 'present',
        version => '2',
        owner => 'erik',
        group => 'erik',
    }

    python::pip { 'Django==1.4.2':
        ensure => 'present',
        virtualenv => '/projects/erik/virtualenvs/phenny',
    }

    package { 'libmysqlclient': 
        ensure => 'latest',
    }

    python::pip { 'MySQL-python':
        ensure => 'present',
        virtualenv => '/projects/erik/virtualenvs/phenny',
        require => Package['libmysqlclient'],
    }

    python::pip { 'South==0.7.6':
        ensure => 'present',
        virtualenv => '/projects/erik/virtualenvs/phenny',
    }

    python::pip { 'coverage':
        ensure => 'latest',
        virtualenv => '/projects/erik/virtualenvs/phenny',
    }

    python::pip { 'django-tables==0.2':
        ensure => 'present',
        virtualenv => '/projects/erik/virtualenvs/phenny',
    }

    python::pip { 'ipython':
        ensure => 'latest',
        virtualenv => '/projects/erik/virtualenvs/phenny',
    }

    python::pip { 'nose':
        ensure => 'latest',
        virtualenv => '/projects/erik/virtualenvs/phenny',
    }

    python::pip { 'requests==1.1.0':
        ensure => 'present',
        virtualenv => '/projects/erik/virtualenvs/phenny',
    }

    python::pip { 'wsgiref':
        ensure => 'present',
        virtualenv => '/projects/erik/virtualenvs/phenny',
    }

}
    
class phenny::configuration {

    mysql::db { 'phenny_scores':
      user     => 'django',
      password => 'PHENNY_SCORES_PASSWORD',
      host     => '%.localhost',
      grant    => ['all'],
    }

    git::repo { 'phennyfyxata':
      path => '/projects/erik/code/phennyfyxata',
      source => 'https://github.com/Venefyxatu/phennyfyxata.git',
      owner => 'erik',
      update => true,
    }

    git::repo { 'phenny_palmersbot':
      path => '/projects/erik/code/phenny',
      source => 'https://github.com/sbp/phenny.git',
      owner => 'erik',
      update => false,
    }

    git::repo { 'evilphenny':
      path => '/projects/erik/code/evilphenny',
      source => 'https://github.com/sbp/phenny.git',
      owner => 'erik',
      update => false,
    }

    file { '/projects/erik/code/phenny/nanowars.py':
        ensure => 'link',
        target => '/projects/erik/code/phennyfyxata/phenny/nanowars.py',
        owner => 'erik',
        group => 'erik',
        require => Git::Repo['phennyfyxata', 'phenny_palmersbot']
    }

    file { '/projects/erik/code/phenny/help.py':
        ensure => 'link',
        target => '/projects/erik/code/phennyfyxata/phenny/help.py',
        owner => 'erik',
        group => 'erik',
        require => Git::Repo['phennyfyxata', 'phenny_palmersbot']
    }

    file { '/home/erik/.phenny':
        ensure => 'link',
        target => '/projects/erik/code/phennyfyxata/.phenny',
        owner => 'erik',
        group => 'erik',
        require => Git::Repo['phennyfyxata']
    }

    exec { "sed -i 's/PLACEHOLDER_PASSWORD/IRC_PASSWORD/' /home/erik/.phenny/*py":
        path => '/usr/bin',
        require => File['/home/erik/.phenny']
    }
}
