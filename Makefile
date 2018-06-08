# Import envars from the environment file, if present:
-include .env

# These override the ARG lines in Dockerfile. Any with ?= will be
# overridden by the make environment and then the .env file:
UBUNTU := bionic
QT := 5.12.0
QTM := $(shell echo $(QT) | cut -f 1-2 -d .)
QTSHA ?= 5e644f8187718830075d3a563d8865d128d2fcfe5bac7315be104f752b508a7e
QTCOMPONENTS ?= gcc_64
QTRUNFILE := qt-opensource-linux-x64-$(QT).run
VCS_REF := $(shell git rev-parse --short HEAD)
VCS_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
BUILD_DATE := $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
DELETE := Docs Examples Tools MaintenanceTool

# On a Mac? Please: brew install coreutils
export PATH := /usr/local/opt/coreutils/libexec/gnubin:$(PATH)

# If you need to change anything below, please raise an issue:
TAG := qt-build:$(UBUNTU)-$(QT)

.PHONY: image fetch kick output-new-shasum

image: $(QTF) qt-opensource-linux-x64-$(QT).run
	echo '$(QTSHA)  $(QTRUNFILE)' | sha256sum -c
	docker build \
		--tag "$(TAG)" \
		--build-arg "QT=$(QT)" \
		--build-arg "QTM=$(QTM)" \
		--build-arg "QTRUNFILE=$(QTRUNFILE)" \
		--build-arg "QTSHA=$(QTSHA)" \
		--build-arg "QTCOMPONENTS=$(QTCOMPONENTS)" \
		--build-arg "VCS_REF=$(VCS_REF)" \
		--build-arg "BUILD_DATE=$(BUILD_DATE)" \
		--build-arg "DELETE=$(DELETE)" \
		.

fetch: $(QTRUNFILE) output-new-shasum

$(QTRUNFILE):
	curl -L -o $(QTRUNFILE) http://download.qt.io/official_releases/qt/$(QTM)/$(QT)/$(QTRUNFILE)

output-new-shasum: $(QTRUNFILE)
	echo QTSHA := `sha256sum $(QTRUNFILE) | cut -f 1 -d ' '`

kick:
	test "$(DOCKER_BUILD_TRIGGER_URL)" # need DOCKER_BUILD_TRIGGER_URL
	curl -H 'Content-Type: application/json' --data '{"source_type": "Branch", "source_name": "$(VCS_BRANCH)"}' -X POST $(DOCKER_BUILD_TRIGGER_URL)
