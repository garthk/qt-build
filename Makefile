# This should match the FROM line in Dockerfile:
UBUNTU := trusty

# These override the ARG lines in Dockerfile:
QT:= 5.7.0
QTM := 5.7
QTSHA := 90a18e855d23930c8013af7424ea6b60fbf4784aa501ccbe2a3a5d966c2700b1

# If you need to change anything below, please raise an issue:
TAG := qt-build:$(UBUNTU)-$(QT)

.PHONY: image

image: $(QTF)
	docker build --build-arg "QT=$(QT) QTM=$(QTM) QTSHA=$(QTSHA)" --tag $(TAG) .
