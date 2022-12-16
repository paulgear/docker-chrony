REGISTRY=
LOGIN=paulgear
REPO=chrony

default: run

build:
	docker build -t $(REGISTRY)$(LOGIN)/$(REPO) .

push:	build
	docker push $(REGISTRY)$(LOGIN)/$(REPO)

run:	build
	docker run --rm --env SSH_AUTHORIZED_KEYS='$(file < $(HOME)/.ssh/id_rsa.pub)' --env PLATFORM_DIAGNOSTICS=true -ti $(REGISTRY)$(LOGIN)/$(REPO)
