# This should match the FROM line in Dockerfile:
UBUNTU := trusty

# These override the ARG lines in Dockerfile:
QT:= 5.9.7
QTM := $(shell echo $(QT) | cut -f 1-2 -d .)
QTSHA := 755d38d400e616b02f27764bf0f332060102d7360042b57a695541e793b27211
QTRUN := qt-opensource-linux-x64-$(QT).run
QTRUN_URL := http://download.qt.io/official_releases/qt/$(QTM)/$(QT)/$(QTRUN)
VCS_REF := $(shell git rev-parse --short HEAD)
BUILD_DATE := $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")

# If you need to change anything below, please raise an issue:
TAG := qt-build:$(UBUNTU)-$(QT)

.PHONY: info image download clean

image:
	docker build \
		--build-arg "QT=$(QT)" \
		--build-arg "QTM=$(QTM)" \
		--build-arg "QTSHA=$(QTSHA)" \
		--build-arg "QTRUN_URL=$(QTSHA)" \
		--build-arg "VCS_REF=$(VCS_REF)" \
		--build-arg "BUILD_DATE=$(BUILD_DATE)" \
		--tag "$(TAG)" .

image-with-download: $(QTRUN)
	# just like 'image' target, but with a local QTRUN_URL
	docker build \
		--build-arg "QT=$(QT)" \
		--build-arg "QTM=$(QTM)" \
		--build-arg "QTSHA=$(QTSHA)" \
		--build-arg "QTRUN_URL=$(QTRUN)" \
		--build-arg "VCS_REF=$(VCS_REF)" \
		--build-arg "BUILD_DATE=$(BUILD_DATE)" \
		--tag "$(TAG)" .

info:
	@echo QT=$(QT)
	@echo QTM=$(QTM)
	@echo QTSHA=$(QTSHA)
	@echo QTRUN=$(QTRUN)
	@echo QTRUN_URL=$(QTRUN_URL)
	@echo VCS_REF=$(VCS_REF)
	@echo BUILD_DATE=$(BUILD_DATE)

download: $(QTRUN)
	# use when working on an image to avoid multiple looong downloads
	echo "$(QTSHA)  $(QTRUN)" | shasum -a 256 -c

$(QTRUN):
	curl -L -o $@ $(QTRUN_URL)

clean:
	rm -f $(QTRUN)

