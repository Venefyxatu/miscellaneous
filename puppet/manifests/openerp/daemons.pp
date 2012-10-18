service { 'postgresql':
    ensure      => running,
    hasrestart  => true,
}

exec { "/usr/local/bin/supervisord -c /etc/supervisord.conf":
    require => File['/etc/supervisord.conf'],
    returns => [0, 2],
}
