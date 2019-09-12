#!/usr/bin/env bash

set -e

mv *jdk*linux*11*.tar.gz /tmp/
mv tce.installed.jdk /tmp

cd /tmp

chmod +x /java-installer.sh
/java-installer.sh

mv usr/local/src/java/jdk11.tcz .
