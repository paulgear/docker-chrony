FROM    ubuntu:bionic

ENV     PKGS="\
byobu \
chrony \
rsync \
ssh \
"

ARG     REGION=ap-southeast-2

RUN     sed -ri -e "s/(archive|security)\.ubuntu\.com/${REGION}.ec2.archive.ubuntu.com/" /etc/apt/sources.list && \
        apt update && \
        apt upgrade -y && \
        apt install --no-install-recommends -y ${PKGS} && \
        apt autoremove --purge -y && \
        rm -rf /var/lib/apt/lists/* && \
        rm -fv /etc/ssh/ssh_host_*key*

USER    root

COPY    authorized_keys /root/.ssh/
COPY    chrony.conf /etc/chrony/
COPY    entrypoint.sh /usr/local/bin/

RUN     chmod 755 /usr/local/bin/entrypoint.sh && chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD     ["-n", "-x"]
