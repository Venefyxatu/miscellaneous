#!/bin/bash

# ##############################################################################
# Script to set up a gentoo chroot on a gentoo installation.
# It assumes without checking (consider this a TODO):
#   * That rsyncd is installed and configured to serve the portage tree
#   * That it is running as root
#   * That you want your chroot in the Europe/Brussels timezone
#   * That you want your chroots under /opt/chroots
#   * That you want to create a chroot called test
#   * That you want portage-latest in combination with stage3-amd64-20130130
#   * That you have time for an emerge --sync
# It:
#   * Checks whether your desired chroot dir already exists.
#      * If so, it will ask about deleting it and exit if not allowed.
#   * Starts rsyncd
#   * Creates the appropriate directories
#   * Downloads if necessary and extracts a stage3 and portage snapshot
#   * Copies your /etc/resolv.conf into the chroot
#   * Mounts /proc and binds /dev and /tmp into the chroot
#   * Configures make.conf and some env variables for root in the chroot
#   * emerge --sync in the chroot with localhost (that's your running system)
#   * Chooses the first profile in the eselect list in the chroot
#   * emerges vim in the chroot
#
# Used a lot of knowledge from https://blog.maxux.net/index.php?post/2012/12/09/Steam-Linux-on-Gentoo-amd64
# ##############################################################################

set -e  # Always Die is a good principle
set -u  # Make sure we don't use any variables we aren't aware of

# ###################
# VARIABLES
# ###################

CHROOT_ROOT='/opt/chroots'
CHROOT_NAME='test'

CHROOT_DIR="${CHROOT_ROOT}/${CHROOT_NAME}"

STAGE_NAME='stage3-amd64-20130130'

# ###################
# FUNCTIONS
# ###################

function setup_steam {
    chroot ${CHROOT_DIR} emerge vanilla-sources
    
    KERNEL_RELEASE=`uname -r`
    cp -rL /usr/src/linux ${CHROOT_DIR}/usr/src/${KERNEL_RELEASE}
    
    cat >> ${CHROOT_DIR}/steam_prerequisites.sh << _EOF_
#!/bin/bash

if [ -e /usr/src/linux ]
then
    rm -f /usr/src/linux
fi

ln -s /usr/src/${KERNEL_RELEASE} /usr/src/linux

mkdir -p /etc/portage
echo 'dev-libs/libxml2 python' >> /etc/portage/package.use

emerge -v dev-libs/libxml2

emerge -v app-emulation/emul-linux-x86-baselibs \
          app-emulation/emul-linux-x86-compat \
          app-emulation/emul-linux-x86-cpplibs \
          app-emulation/emul-linux-x86-db \
          app-emulation/emul-linux-x86-gtklibs \
          app-emulation/emul-linux-x86-gtkmmlibs \
          app-emulation/emul-linux-x86-medialibs \
          app-emulation/emul-linux-x86-motif \
          app-emulation/emul-linux-x86-opengl \
          app-emulation/emul-linux-x86-qtlibs \
          app-emulation/emul-linux-x86-sdl \
          app-emulation/emul-linux-x86-soundlibs \
          app-emulation/emul-linux-x86-xlibs
_EOF_

    chmod 755 ${CHROOT_DIR}/steam_prerequisites.sh

    chroot ${CHROOT_DIR} /bin/bash /steam_prerequisites.sh

    cat >> ${CHROOT_DIR}/steam.sh << _EOF_
#!/bin/bash
wget http://media.steampowered.com/client/installer/steam.deb
ar xv steam.deb
tar -xvf data.tar.gz -C /
cd /usr/
mv lib/steam/ lib64/
rm -r /usr/lib
ln -s lib64 lib
_EOF_

    chmod 755 ${CHROOT_DIR}/steam.sh
    chroot ${CHROOT_DIR} /bin/bash /steam.sh

}

function setup_chrootfiles {
    if [ ! -e portage-latest.tar.bz2 ]
    then
        wget http://mirror.leaseweb.com/gentoo/snapshots/portage-latest.tar.bz2 
    fi

    if [ ! -e ${STAGE_NAME}.tar.bz2 ]
    then
        wget http://mirror.leaseweb.com/gentoo/releases/amd64/current-stage3/${STAGE_NAME}.tar.bz2
    fi

    tar xf ${STAGE_NAME}.tar.bz2 -C ${CHROOT_NAME}
    tar xf portage-latest.tar.bz2 -C ${CHROOT_NAME}
    cp /etc/resolv.conf ${CHROOT_DIR}/etc/
}

function mount_chroot {
    mount -t proc none ${CHROOT_DIR}/proc
    mount -o bind /dev ${CHROOT_DIR}/dev
    mount -o bind /tmp ${CHROOT_DIR}/tmp
}

function create_base_configure_script {
    cat >> ${CHROOT_DIR}/base_configure_chroot.sh << __EOF__
#!/bin/bash
env-update

echo 'export PS1="(chroot) \${PS1}"' >> /root/.bashrc
echo 'export LANG="en_US.UTF-8"' >> /root/.bashrc

cp /usr/share/zoneinfo/Europe/Brussels /etc/localtime
echo "Europe/Brussels" > /etc/timezone

cat >> /etc/make.conf << _EOF_
USE="mmx sse sse2 X python -cups -introspection -tools -llvm opengl -kmod"
VIDEO_CARDS="intel"
INPUT_DEVICES="evdev synaptics"
LINGUAS="en"
ACCEPT_KEYWORDS="~amd64"
SYNC="rsync://localhost/gentoo-portage"
_EOF_

emerge --sync

eselect profile set 1
__EOF__

    chmod 755 ${CHROOT_DIR}/base_configure_chroot.sh
}

# ###################
# ACTUAL SCRIPT
# ###################

if [ -d ${CHROOT_DIR} ]
then
    echo "${CHROOT_DIR} already exists. Type 'yes' to remove."
    read OK_REMOVE
    if [ ${OK_REMOVE} != "yes" ]
    then
        echo "Please specify a different chroot name or clean up manually."
        exit 1
    else
        set +e
        mount | grep /opt/chroots/test
        EXITCODE=$?
        set -e
        if [[ ${EXITCODE} -eq 0 ]]
        then
            echo "There are still mounts in ${CHROOT_DIR}. Please unmount first."
            exit 1
        else
            echo "Cleaning up"
            rm -rf ${CHROOT_DIR}
        fi
    fi
fi


# Make sure rsync is running
/etc/init.d/rsyncd start

mkdir -p ${CHROOT_DIR}
pushd ${CHROOT_ROOT}

setup_chrootfiles
mount_chroot

create_base_configure_script

chroot ${CHROOT_DIR} /bin/bash base_configure_chroot.sh

chroot ${CHROOT_DIR} emerge vim

setup_steam

popd

set +e
set +u
