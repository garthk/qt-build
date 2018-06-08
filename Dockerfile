# Build stage 0: install the Qt installer dependencies
FROM ubuntu:bionic as installerdeps
RUN apt-get update -q && \
    DEBIAN_FRONTEND=noninteractive apt-get install -q -y --no-install-recommends \
        ca-certificates \
        default-jdk \
        libfontconfig1 \
        libice6 \
        libsm6 \
        libx11-xcb1 \
        libxext6 \
        libxrender1 \
        p7zip \
        xvfb \
    && apt-get clean

# Build stage 1: run the Qt installer
FROM installerdeps as qtinstalled

# WARNING: these arguments below MUST be kept up to date by hand for builds
# on Docker Hub to work like they did on your machine, AND MUST match between
# all build stages. Look for them again further below.
ARG QT=5.7.1
ARG QTM=5.7
ARG QTSHA=fdf6b4fb5ee9ade2dec74ddb5bea9e1738911e7ee333b32766c4f6527d185eb4
ARG QTCOMPONENTS=gcc_64

# The rest can be left to the default:
ARG QTRUNFILE=http://download.qt.io/official_releases/qt/${QTM}/${QT}/qt-opensource-linux-x64-${QT}.run

# Steps, kicking off from the tail end of installerdeps above:
ADD qt-installer-noninteractive.qs /tmp/qt/script.qs
ADD ${QTRUNFILE} /tmp/qt/installer.run
ENV QTM=$QTM
ENV QTSHA=$QTSHA
ENV QTCOMPONENTS=$QTCOMPONENTS
# use bash for RUN until the next FROM, so we can use bash strict mode
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
SHELL ["/bin/bash", "-c"]
RUN set -euo pipefail \
    && echo "${QTSHA}  /tmp/qt/installer.run" | sha256sum -c \
    && chmod +x /tmp/qt/installer.run \
    && xvfb-run -e /dev/stderr /tmp/qt/installer.run --script /tmp/qt/script.qs \
    && rm -rf /tmp/qt

        # | egrep -v '\[[0-9]+\] Warning: (Unsupported screen format)|((QPainter|QWidget))' \
# Build stage 2: copy Qt from the first stage, thus needing fewer packages
# and leaving less of a mess e.g. the build layer with /tmp/qt/installer.run
FROM ubuntu:bionic

# WARNING: these arguments below MUST be kept up to date by hand for builds
# on Docker Hub to work like they did on your machine, AND MUST match between
# all build stages. Look for them again further above.
ARG QT=5.7.1
ARG QTM=5.7
ARG QTCOMPONENTS=gcc_64

# The rest can be left to the default:
ARG VCS_REF
ARG BUILD_DATE

LABEL org.label-schema.build-date="$BUILD_DATE" \
      org.label-schema.name="qt-build" \
      org.label-schema.description="A headless Qt $QTM build environment for Ubuntu" \
      org.label-schema.url="e.g. https://github.com/garthk/qt-build" \
      org.label-schema.vcs-ref="$VCS_REF" \
      org.label-schema.vcs-url="https://github.com/garthk/qt-build.git" \
      org.label-schema.version="$QT" \
      org.label-schema.schema-version="1.0"

RUN apt-get update -q && \
    DEBIAN_FRONTEND=noninteractive apt-get install -q -y --no-install-recommends \
        locales \
        build-essential \
        p7zip \
    && apt-get clean

COPY --from=qtinstalled /opt/qt /opt/qt
RUN for COMPONENT in `echo ${QTCOMPONENTS} | tr , ' '`; do echo /opt/qt/${QTM}/${COMPONENT}/lib >> /etc/ld.so.conf.d/qt-${QTM}.conf; done
RUN locale-gen en_US.UTF-8 && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/qt/${QTM}/gcc_64/bin
