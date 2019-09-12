FROM tatsushid/tinycore:10.0-x86_64 AS jdk11-tcz

LABEL maintainer="hpmtissera@gmail.com"

RUN tce-load -wci bash
RUN tce-load -wci java-installer

COPY *jdk*linux*11*.tar.gz .
COPY java-installer.sh .
COPY tce.installed.jdk .
