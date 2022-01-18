FROM    paulgear/base

ARG     PKGS="\
chrony \
ssh \
"
ENV     DEBIAN_FRONTEND=noninteractive

RUN     apt update && \
        apt install --no-install-recommends -y ${PKGS} && \
        apt upgrade --autoremove --purge -y && \
        rm -rf /var/lib/apt/lists/* && \
        rm -fv /etc/ssh/ssh_host_*key*

USER    root

COPY    chrony.conf /etc/chrony/
COPY    entrypoint.sh /usr/local/bin/

RUN     chmod 755 /usr/local/bin/entrypoint.sh

ENV     SSH_AUTHORIZED_KEYS="# This should be replaced at runtime with your authorised ssh key(s)"
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD     ["-d", "-n", "-x"]
