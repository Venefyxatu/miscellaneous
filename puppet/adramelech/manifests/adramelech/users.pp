user { 'erik':
    ensure => 'present',
    shell => '/bin/zsh',
    require => Package['zsh'],
}

file { '/home/erik/source':
    ensure => 'directory',
    owner => 'erik',
    group => 'erik',
    require => User['erik'],
}

git::repo { 'Configurations':
    path => '/home/erik/source/Configurations',
    source => 'git://github.com/Venefyxatu/Configurations',
    owner => 'erik',
    require => File['/home/erik/source'],
    update => true,
}

git::repo { 'zsh-syntax-highlighting':
    path => '/home/erik/source/zsh-syntax-highlighting',
    source => 'git://github.com/zsh-users/zsh-syntax-highlighting.git',
    owner => 'erik',
    require => File['/home/erik/source'],
    update => true,
}

file { '/home/erik/.zshrc':
    ensure => 'link',
    target => '/home/erik/source/Configurations/zsh/zshrc',
    require => Git::Repo['Configurations'],
    owner => 'erik',
    group => 'erik',
}

file { '/home/erik/.oh-my-zsh':
    ensure => 'link',
    target => '/home/erik/source/Configurations/zsh/oh-my-zsh',
    owner => 'erik',
    group => 'erik',
}

file { '/home/erik/.oh-my-zsh/plugins/zsh-syntax-highlighting':
    ensure => 'link',
    target => '/home/erik/source/zsh-syntax-highlighting',
    require => Git::Repo['zsh-syntax-highlighting'],
    owner => 'erik',
    group => 'erik',
}

file { '/home/erik/.gitconfig':
    ensure => 'link',
    target => '/home/erik/source/Configurations/git/gitconfig',
    owner => 'erik',
    group => 'erik',
}

file { '/home/erik/.tmux.conf':
    ensure => 'link',
    target => '/home/erik/source/Configurations/tmux/tmux.conf',
    owner => 'erik',
    group => 'erik',
}

file { '/home/erik/.virtualenvs':
    ensure => 'link',
    target => '/projects/erik/virtualenvs',
    owner => 'erik',
    group => 'erik',
}
