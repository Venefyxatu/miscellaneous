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
    version => '2',
    virtualenv => true,
}

package { 'libxt':
    ensure => latest,
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
