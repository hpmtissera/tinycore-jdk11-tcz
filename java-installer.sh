#!/bin/sh
#
#  Java installer for Tiny Core Linux
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License along
#  with this program; if not, write to the Free Software Foundation, Inc.,
#  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
#  Copyright (c) 2012 Sercan Arslan <arslanserc@gmail.com>
#  Updated by Anno Langen anno.langen@gmail.com
#

THIS=`basename $0`

die () {
    echo $*
    exit 1
}

[ `id -u` == 0 ] || die "You need to run $THIS as root!"

HERE="$PWD"
TCUSER=$(cat /etc/sysconfig/tcuser)
TCEDIR=/etc/sysconfig/tcedir
JAVA_INSTALLER_SRC=/usr/local/java-installer

# java architecture
ARCH=x64
SOURCE=$(ls *jdk*linux*11*.tar.gz | tail -1)

[ -n "$SOURCE" ] || \
    die "*jdk*linux*11*.tar.gz not found! exiting ..."

# extensions to be created
JDK="jdk11"
WRKDIR=`tar -tzf *jdk*linux*11*.tar.gz | head -1 | cut -f1 -d"/"`

TMPDIR="/tmp/usr/local/src/java"

JDK_ROOT="$TMPDIR/$JDK"

build_clean() {

   [ -d $TMPDIR ] && sudo rm -r $TMPDIR

   return 0
}

build_unpack() {
   [ -d $TMPDIR ] && rm -rf $TMPDIR
   mkdir -p $TMPDIR

   /usr/local/bin/tar xf $HERE/$SOURCE -C $TMPDIR || return 1

   return 0
}

build_create() {
  mkdir -p $TMPDIR/$WRKDIR
  cd $TMPDIR/$WRKDIR

  # main files for jdk
  mkdir -p ${JDK_ROOT}/usr/local/java
  cp -R . ${JDK_ROOT}/usr/local/java || return 1

  # remove unneccessary files
  find $JDK_ROOT/usr/local/java -name '*\.bat' -delete

  # tce install script
  install -Dm 775 /tmp/tce.installed.jdk $JDK_ROOT/usr/local/tce.installed/$JDK
  chmod -R 775 $JDK_ROOT/usr/local/tce.installed
  chown -R root:staff $JDK_ROOT/usr/local/tce.installed

  cd $TMPDIR
  mksquashfs $JDK $JDK.tcz || return 1
  md5sum $JDK.tcz > $JDK.tcz.md5.txt
  cd $JDK
  find -not -type d > ../$JDK.tcz.list
  cd ..

  return 0
}

echo -e "Cleaning ... \c"
build_clean
if [ "$?" -gt 0 ]
then
     echo "failed !"
     exit 1
else
    echo "successful ! "
fi

echo -e "Unpacking ... \c"
build_unpack
if [ "$?" -gt 0 ]
then
     echo "failed !"
     exit 1
else
    echo "successful ! "
fi

echo -e "Creating ... \c"
build_create
if [ "$?" -gt 0 ]
then
     echo "failed !"
     exit 1
else
    echo "successful ! "
fi

cat <<EOF
Congratulations, All Done !
EOF

exit 0
