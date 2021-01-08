ARG     UBUNTU_RELEASE=focal
FROM    ubuntu:${UBUNTU_RELEASE}

ARG     PKGS="\
byobu \
chrony \
rsync \
ssh \
"
#ARG    MIRROR=http://ap-southeast-2.ec2.archive.ubuntu.com
ARG     MIRROR=http://azure.archive.ubuntu.com
ARG     UBUNTU_RELEASE=focal
ENV     DEBIAN_FRONTEND=noninteractive

RUN     sed -ri \
                -e "s^http://.*archive\.ubuntu\.com^${MIRROR}^" \
                -e "1i deb ${MIRROR}/ubuntu/ ${UBUNTU_RELEASE}-security main restricted universe multiverse\n" \
                /etc/apt/sources.list && \
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
