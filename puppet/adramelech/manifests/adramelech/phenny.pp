
class phenny::packages {
    package { 'virtualenvwrapper':
        ensure => 'latest',
    }

    python::virtualenv { '/home/erik/virtualenvs/phenny':
        ensure => 'present',
    }

    python::pip { 'Django==1.4.2':
        ensure => 'present',
        virtualenv => '/home/erik/virtualenvs/phenny',
    }

    python::pip { 'MySQL-python':
        ensure => 'present',
        virtualenv => '/home/erik/virtualenvs/phenny',
    }

    python::pip { 'South==0.7.6':
        ensure => 'present',
        virtualenv => '/home/erik/virtualenvs/phenny',
    }

    python::pip { 'coverage':
        ensure => 'latest',
        virtualenv => '/home/erik/virtualenvs/phenny',
    }

    python::pip { 'django-tables==0.2':
        ensure => 'present',
        virtualenv => '/home/erik/virtualenvs/phenny',
    }

    python::pip { 'ipython':
        ensure => 'latest',
        virtualenv => '/home/erik/virtualenvs/phenny',
    }

    python::pip { 'nose':
        ensure => 'latest',
        virtualenv => '/home/erik/virtualenvs/phenny',
    }

    python::pip { 'requests==1.1.0':
        ensure => 'present',
        virtualenv => '/home/erik/virtualenvs/phenny',
    }

    python::pip { 'wsgiref':
        ensure => 'present',
        virtualenv => '/home/erik/virtualenvs/phenny',
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
      path => '/home/erik/source/phennyfyxata',
      source => 'https://github.com/Venefyxatu/phennyfyxata.git',
      owner => 'erik',
      update => true,
    }

    git::repo { 'phenny_palmersbot':
      path => '/home/erik/source/phenny',
      source => 'https://github.com/sbp/phenny.git',
      owner => 'erik',
      update => false,
    }

    git::repo { 'evilphenny':
      path => '/home/erik/source/evilphenny',
      source => 'https://github.com/sbp/phenny.git',
      owner => 'erik',
      update => false,
    }

    file { '/home/erik/source/phenny/nanowars.py':
        ensure => 'link',
        target => '/home/erik/source/phennyfyxata/phenny/nanowars.py',
        owner => 'erik',
        group => 'erik',
        require => Git::Repo['phennyfyxata', 'phenny_palmersbot']
    }

    file { '/home/erik/source/phenny/help.py':
        ensure => 'link',
        target => '/home/erik/source/phennyfyxata/phenny/help.py',
        owner => 'erik',
        group => 'erik',
        require => Git::Repo['phennyfyxata', 'phenny_palmersbot']
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
}
