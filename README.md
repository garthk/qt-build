# qt-build

A headless [Qt] 5.7 build environment for Ubuntu, tested with
[18.04 LTS (Bionic Badger)][bionic].

[![](https://images.microbadger.com/badges/image/garthk/qt-build.svg)](https://microbadger.com/images/garthk/qt-build "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/garthk/qt-build.svg)](https://microbadger.com/images/garthk/qt-build "Get your own version badge on microbadger.com")

## Usage

* `docker pull garthk/qt-build:bionic-5.7.1`
* `docker run -t -i --rm -v $PWD:$PWD garthk/qt-build:trusty-5.7.1 bash`
* `qmake` in the container

## Selected Components

* `qt.*.gcc_64` e.g. `qt.57.gcc_64`

Set `QTCOMPONENTS` in your `.env` and rebuild to add more.

## Building

* `brew install coreutils ; brew unlink coreutils`, if you're on a Mac
* `make`

Or:

* `docker pull ubuntu:bionic`
* `docker build .`

Use `docker-build --build-arg` to override `QT`, `QTM`, `QTSHA`, and `QTCOMPONENTS` to build with a different version of Qt.

### Building on Docker Hub

* Copy `.env-example` to `.env`
* Fix `DOCKER_BUILD_TRIGGER_URL`
* `make kick`

Docker Hub relies solely on `Dockerfile`, so you'll have to update all `ARG` values in the `Makefile` before committing and pushing.

## Upgrading

* Alter `QT` and `QTM` in Makefile
* `make fetch`
* Alter `QTSHA` in Makefile
* Alter `qt-installer-noninteractive.qs`
* `make image`
* Test

## Credits

* [Xian Nox][xiannox] for the Qt 5.7-beta image

[Qt]: https://www.qt.io
[trusty]: http://releases.ubuntu.com/14.04/
[xiannox]: https://hub.docker.com/u/xiannox
