FROM    paulgear/base

ARG     PKGS="\
apache2 \
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
COPY    000-default.conf /etc/apache2/sites-available/
COPY    entrypoint.sh /usr/local/bin/

RUN     chmod 755 /usr/local/bin/entrypoint.sh

HEALTHCHECK --start-period=12s CMD curl -f http://127.0.0.1/chrony/measurements.log

EXPOSE  80
ENV     SSH_AUTHORIZED_KEYS="# This should be replaced at runtime with your authorised ssh key(s)"
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD     ["-d", "-n", "-x"]
