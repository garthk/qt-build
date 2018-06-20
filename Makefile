# Import envars from the environment file, if present:
-include .env

# This should match the ARG UBUNTU line in Dockerfile for Docker Hub:
UBUNTU := trusty

# These override the ARG lines in Dockerfile. Any with ?= will be
# overridden by the make environment and then the .env file:
QT ?= 5.7.1
QTM ?= 5.7
QTSHA ?= fdf6b4fb5ee9ade2dec74ddb5bea9e1738911e7ee333b32766c4f6527d185eb4
QTCOMPONENTS ?= gcc_64
QTRUNFILE := qt-opensource-linux-x64-$(QT).run
VCS_REF := $(shell git rev-parse --short HEAD)
VCS_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
BUILD_DATE := $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")

# On a Mac? Please: brew install coreutils
export PATH := /usr/local/opt/coreutils/libexec/gnubin:$(PATH)

# If you need to change anything below, please raise an issue:
TAG := qt-build:$(UBUNTU)-$(QT)

.PHONY: image fetch kick output-new-shasum

image: $(QTF) qt-opensource-linux-x64-$(QT).run
	echo '$(QTSHA)  $(QTRUNFILE)' | sha256sum -c
	docker build \
		--tag "$(TAG)" \
		--build-arg "UBUNTU=$(UBUNTU)" \
		--build-arg "QT=$(QT)" \
		--build-arg "QTM=$(QTM)" \
		--build-arg "QTRUNFILE=$(QTRUNFILE)" \
		--build-arg "QTSHA=$(QTSHA)" \
		--build-arg "QTCOMPONENTS=$(QTCOMPONENTS)" \
		--build-arg "VCS_REF=$(VCS_REF)" \
		--build-arg "BUILD_DATE=$(BUILD_DATE)" \
		.

fetch: $(QTRUNFILE) output-new-shasum

$(QTRUNFILE):
	curl -L -o $(QTRUNFILE) http://download.qt.io/official_releases/qt/$(QTM)/$(QT)/$(QTRUNFILE)

output-new-shasum: $(QTRUNFILE)
	echo QTSHA := `sha256sum $(QTRUNFILE) | cut -f 1 -d ' '`

kick:
	test "$(DOCKER_BUILD_TRIGGER_URL)" # need DOCKER_BUILD_TRIGGER_URL
	curl -H 'Content-Type: application/json' --data '{"source_type": "Branch", "source_name": "$(VCS_BRANCH)"}' -X POST $(DOCKER_BUILD_TRIGGER_URL)
