package { 'tmux':
    ensure => latest,
}

package { 'git': 
    ensure => latest,
}

package { 'vim':
    ensure => latest,
}

package { 'zsh': 
    ensure => latest,
}

class { 'python':
    version => 'system',
    dev => false,
    virtualenv => true,
}

package { 'lua':
    ensure => latest,
}

package { 'sed':
    ensure => latest,
}

package { 'colordiff':
    ensure => latest,
}
