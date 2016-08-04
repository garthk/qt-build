# qt-build

A headless [Qt] 5.7 build environment for Ubuntu, tested with
[14.04.4 LTS (Trusty Tahr)][trusty].

## Usage

* `docker pull garthk/qt-build:trusty-5.7.0`
* `docker run -t -i --rm -v $PWD:$PWD garthk/qt-build:trusty-5.7.0 bash`
* `qmake` in the container

## Selected Components

* `qt.57.gcc_64`

Edit `qt-installer-noninteractive.qs` and build your own image to add more.

## Building

* `make`

Or:

* `docker pull ubuntu:trusty`
* `docker build .`

Use `docker-build --build-arg` to override `QT`, `QTM`, and `QTSHA` to build
with a different version of Qt.

## Credits

* [Xian Nox][xiannox] for the Qt 5.7-beta image

[Qt]: https://www.qt.io
[trusty]: http://releases.ubuntu.com/14.04/
[xiannox]: https://hub.docker.com/u/xiannox
