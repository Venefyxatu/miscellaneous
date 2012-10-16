file { "/opt/code/":
    ensure => directory,
}

file { "/opt/code/openerp": 
    ensure    => directory,
    owner     => openerp,
    group     => openerp,
    require   => File['/opt/code']
}

file { "/root/.bazaar":
     ensure    => directory
}

file { "/root/.bazaar/bazaar.conf":
    ensure      => file,
    content     => "[DEFAULT]
email = Erik Heeren <erik.heeren@abc-groep.be>
",
    require => File['/root/.bazaar'],
}

vcsrepo { "/opt/code/openerp/openobject-server":
    ensure                => present,
    provider              => bzr,
    source                => 'lp:openobject-server',
    revision              => 'tag:6.1.1',
    require => File['/opt/code/openerp', '/root/.bazaar/bazaar.conf'],
}

file { "/opt/code/openerp/openobject-server":
    owner => openerp,
    group => openerp,
    recurse => true,
    require => VcsRepo['/opt/code/openerp/openobject-server']
}

vcsrepo { "/opt/code/openerp/openobject-addons":
    ensure                => present,
    provider              => bzr,
    source                => 'lp:openobject-addons',
    revision              => 'tag:6.1.1',
    require => File['/opt/code/openerp', '/root/.bazaar/bazaar.conf'],
}

file { "/opt/code/openerp/openobject-addons":
    owner => openerp,
    group => openerp,
    recurse => true,
    require => VcsRepo['/opt/code/openerp/openobject-addons']
}

vcsrepo { "/opt/code/openerp/openerp-web":
    ensure                => present,
    provider              => bzr,
    source                => 'lp:openerp-web',
    revision              => 'tag:6.1.1',
    require => File['/opt/code/openerp', '/root/.bazaar/bazaar.conf'],
}

file { "/opt/code/openerp/openerp-web":
    owner => openerp,
    group => openerp,
    recurse => true,
    require => VcsRepo['/opt/code/openerp/openerp-web']
}

vcsrepo { "/opt/code/miscellaneous":
    ensure                => latest,
    provider              => git,
    source                => 'https://github.com/Venefyxatu/miscellaneous.git',
        require => Package["supervisor"],
}
