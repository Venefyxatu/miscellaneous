portage::package { 'sys-apps/net-tools':
    ensure => latest,
    keywords => '~amd_64'
}

portage::package { 'app-admin/puppet':
    ensure => latest,
    keywords => '~amd_64'
}

portage::package { 'dev-ruby/hiera':
    ensure => latest,
    keywords => '~amd64'
}

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

package { 'iproute2':
    ensure => latest,
}

package { 'tcpdump':
    ensure => latest,
}

package { 'strace':
    ensure => latest,
}
class { 'python':
    version => 'system',
    dev => true,
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

class { 'sudo': }

sudo::conf { 'admins':
    priority => 20,
    content => '%admins ALL=(ALL) ALL'
}

portage::makeconf { 'use':
    content => 'mmx sse sse2 gnutls device-mapper sqlite extras consolekit mailwrapper mysql apache2 a52 acpi ldap kerberos samba curl threads dbus avahi udev python zsh-completion -hal -arts -kde -qt3 -qt4 -glitz',
    ensure => 'present',
}

portage::makeconf { 'CFLAGS':
    content => '-O2 -pipe',
    ensure => 'present',
}

portage::makeconf { 'CXXFLAGS':
    content => '${CFLAGS}',
    ensure => 'present',
}

portage::makeconf { 'CHOST':
    content => 'x86_64-pc-linux-gnu',
    ensure => 'present',
}

portage::makeconf { 'GENTOO_MIRRORS':
    content => 'http://ftp.snt.utwente.nl/pub/os/linux/gentoo/ http://ftp.belnet.be/mirror/rsync.gentoo.org/gentoo/ http://gentoo.tiscali.nl',
    ensure => 'present',
}
