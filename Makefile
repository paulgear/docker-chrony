LOGIN=paulgear
REPO=chrony

default:
	docker build -t $(LOGIN)/$(REPO) .
	docker push $(LOGIN)/$(REPO)
