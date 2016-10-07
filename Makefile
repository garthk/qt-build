# This should match the FROM line in Dockerfile:
UBUNTU := trusty

# These override the ARG lines in Dockerfile:
QT:= 5.7.0
QTM := 5.7
QTSHA := 90a18e855d23930c8013af7424ea6b60fbf4784aa501ccbe2a3a5d966c2700b1
VCS_REF := $(shell git rev-parse --short HEAD)
BUILD_DATE := $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")

# If you need to change anything below, please raise an issue:
TAG := qt-build:$(UBUNTU)-$(QT)

.PHONY: image

image: $(QTF)
	docker build --build-arg "QT=$(QT)" --build-arg "QTM=$(QTM)" --build-arg "QTSHA=$(QTSHA)" --build-arg "VCS_REF=$(VCS_REF)" --build-arg "BUILD_DATE=$(BUILD_DATE)" --tag "$(TAG)" .
