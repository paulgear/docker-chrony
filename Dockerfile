FROM    paulgear/base

ARG     PKGS="\
chrony \
ssh \
"
ENV     DEBIAN_FRONTEND=noninteractive

RUN     apt update && \
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
