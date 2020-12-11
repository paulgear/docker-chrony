FROM    ubuntu:bionic

ARG     PKGS="\
byobu \
chrony \
rsync \
ssh \
"
#ARG    MIRROR=http://ap-southeast-2.ec2.archive.ubuntu.com
ARG     MIRROR=http://azure.archive.ubuntu.com
ARG     DEBIAN_FRONTEND=noninteractive

RUN     sed -ri -e "s^http://(archive|security)\.ubuntu\.com^${MIRROR}^" /etc/apt/sources.list && \
        apt update && \
        apt upgrade -y && \
        apt install --no-install-recommends --autoremove --purge -y ${PKGS} && \
        rm -rf /var/lib/apt/lists/* && \
        rm -fv /etc/ssh/ssh_host_*key*

USER    root

COPY    chrony.conf /etc/chrony/
COPY    entrypoint.sh /usr/local/bin/

RUN     chmod 755 /usr/local/bin/entrypoint.sh

ENV     SSH_AUTHORIZED_KEYS="# This should be replaced at runtime with your authorised ssh key(s)"
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD     ["-n", "-x"]
