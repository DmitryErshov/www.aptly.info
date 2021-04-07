BRANCH := $(shell git rev-parse --abbrev-ref HEAD)

ifeq ($(BRANCH),master)
DESTINATION = s3://www.aptly.info/
else
ifeq ($(TRAVIS_PULL_REQUEST),false)
DESTINATION = s3://www.aptly.info/
else
DESTINATION = s3://beta.aptly.info/
endif
endif

all: prepare deploy

env:
	virtualenv env
	env/bin/pip install s3cmd

prepare: env

	go version
#	go get -u -v github.com/gohugoio/hugo
	go install github.com/gohugoio/hugo@latest

links:
	linkchecker http://localhost:1313/

deploy:
	hugo
