REGISTRY=
LOGIN=paulgear
REPO=chrony

default: push

build:
	docker build -t $(REGISTRY)$(LOGIN)/$(REPO) .

push:	build
	docker push $(REGISTRY)$(LOGIN)/$(REPO)

run:	build
	docker run --rm --env SSH_AUTHORIZED_KEYS='$(file < $(HOME)/.ssh/id_rsa.pub)' -ti $(REGISTRY)$(LOGIN)/$(REPO)
