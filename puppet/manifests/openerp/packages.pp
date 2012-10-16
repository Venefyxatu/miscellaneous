package { 'postgresql':
    ensure   => installed,
}

package { 'python-pip':
    ensure  => installed,
}

package { 'bzr':
    ensure   => installed,
}

package { "psycopg2":
        ensure => latest,
        provider => pip,
        require => Package['python-pip', 'libpq-dev', 'python-dev'],
}

package { "lxml":
        ensure => latest,
        provider => pip,
        require => Package['python-pip'],
}

package { "pytz":
        ensure => latest,
        provider => pip,
        require => Package['python-pip'],
}

package { "reportlab":
        ensure => latest,
        provider => pip,
        require => Package['python-pip'],
}

package { "python-pychart":
        ensure => installed,
}

package { "mako":
        ensure => latest,
        provider => pip,
        require => Package['python-pip'],
}

package { "python-dateutil":
        ensure => latest,
        provider => pip,
        require => Package['python-pip'],
}

package { "supervisor":
        ensure => latest,
        provider => pip,
        require => Package['python-pip'],
}

package { "gunicorn":
        ensure => latest,
        provider => pip,
        require => Package['python-pip'],
}

package { "psutil":
        ensure => latest,
        provider => pip,
        require => Package['python-pip'],
}

package { 'libpq-dev': 
    ensure => latest,
}

package { 'python-dev': 
    ensure => latest,
}

package { 'libxml2-dev':
    ensure => installed
}
package { 'libxslt-dev':
    ensure => installed
}
