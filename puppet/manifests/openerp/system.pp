group { 'openerp':
    ensure => present,
}

user { 'openerp':
   ensure => present,
   gid => openerp,
}

file { '/var/run/openerp':
   ensure => directory,
   group => openerp,
   owner => openerp,
}

file { '/var/log/supervisor':
   ensure => directory,
   group => openerp,
   owner => openerp,
}

file { '/var/log/openerp':
   ensure => directory,
   group => openerp,
   owner => openerp,
}

file { '/opt/code/openerp/openobject-server/gunicorn.conf.py':
   owner  => openerp,
   group  => openerp,
   ensure => file,
   source => '/opt/code/miscellaneous/openerp/gunicorn.conf.py',
   require => Vcsrepo['/opt/code/miscellaneous'],
}

file { '/etc/supervisord.conf':
    ensure => file,
    source => '/opt/code/miscellaneous/supervisor/supervisord.conf',
    require => Vcsrepo['/opt/code/miscellaneous'], 
}

exec { "/bin/sed -i 's/PASSWORD/PASSWORD_HERE/' /etc/supervisord.conf":
    require => File['/etc/supervisord.conf'],
}

exec { "/bin/sed -i 's/PASSWORD/\"PASSWORD_HERE\"/' /opt/code/openerp/openobject-server/gunicorn.conf.py":
    require => [Vcsrepo['/opt/code/openerp/openobject-server'],
                File [ '/opt/code/openerp/openobject-server/gunicorn.conf.py']]
}
