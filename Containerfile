# Multi-stage Containerfile for building the pelican-inelegant
# container, as used by the pelican-inelegant github action.


# pelican-inelegant includes a selection of plugins pre-installed.
# These are the git-based pelican plugins. We won't have git available
# in the final container, so let's use a stage just to fetch and prune
# the plugins git repository. Note that we're not using ADD as
# currently buildah doesn't support git refs. We'll also use this to
# get the stork binary.

FROM ubuntu:latest AS PLUGINS

WORKDIR /pelican

RUN apt-get update

RUN apt-get install -y git && \
  git clone --depth=1 --single-branch --branch master --no-tags \
  https://github.com/getpelican/pelican-plugins.git /pelican/plugins

# We installed these plugins via requirements.txt, and don't want
# these old copies to interfere
RUN rm -rf /pelican/plugins/.git \
           /pelican/plugins/image_process \
           /pelican/plugins/liquid_tags \
           /pelican/plugins/series


# The stork-search binary is needed by the pelican-search plugin, but
# isn't packaged for alpine. We'll need to build it via cargo, so
# let's do that in an intermediate container and just steal the
# resulting binary later. We're using the rust alpine image as the
# basis to ensure the binary is compatible when copied over to the
# python alpine image

FROM rust:alpine AS STORK

WORKDIR /stork

ENV RUSTFLAGS="-Clink-arg=-s -Cstrip=symbols -Ctarget-feature=-crt-static"

ARG STORKVER=1.6.0

RUN apk add --no-cache build-base openssl openssl-dev pkgconf && \
  cargo install stork-search@"$STORKVER" --root /stork

RUN apk add --no-cache wget && \
  wget https://files.stork-search.net/releases/v"$STORKVER"/stork.js && \
  wget https://files.stork-search.net/releases/v"$STORKVER"/stork.js.map && \
  wget https://files.stork-search.net/releases/v"$STORKVER"/stork.wasm && \
  wget https://files.stork-search.net/releases/v"$STORKVER"/basic.css && \
  wget https://files.stork-search.net/releases/v"$STORKVER"/dark.css


# pelican-inelegant inherits some node dependencies from the original
# elegant theme. In order to produce the final CSS and minified JS,
# we'll use a node container

FROM node:20 AS BUILD

WORKDIR /build

COPY package.json yarn.lock .
RUN yarnpkg

COPY gulpfile.babel.js .
COPY source/ /build/source/
COPY --from=STORK /stork/stork.js /build/source/js/stork.js
COPY --from=STORK /stork/basic.css /build/source/css/stork.css

RUN npx gulp


# the final pelican-inelegant container itself

FROM python:3.11-alpine

ARG AUTHOR_EMAIL="obriencj@gmail.com"
ARG GIT_REPO="https://github.com/obriencj/pelican-inelegant.git"
ARG GIT_COMMIT=""
ARG PROJECT_DESC="Inelegant themed Pelican site generator"
ARG PROJECT_NAME="pelican-inelegant"
ARG PROJECT_URL="https://github.com/obriencj/pelican-inelegant"

LABEL \
    org.label-schema.description="${PROJECT_DESC}" \
    org.label-schema.name="${PROJECT_NAME}" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="${PROJECT_URL}" \
    org.label-schema.vcs-ref="${GIT_COMMIT}" \
    org.label-schema.vcs-url="${PROJECT_URL}" \
    org.opencontainers.image.authors="${AUTHOR_EMAIL}" \
    org.opencontainers.image.description="${PROJECT_DESC}" \
    org.opencontainers.image.revision="${GIT_COMMIT}" \
    org.opencontainers.image.source="${GIT_REPO}" \
    org.opencontainers.image.title="${PROJECT_NAME}" \
    org.opencontainers.image.url="${PROJECT_URL}"


ENV \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PLUGIN_PATHS=/pelican/plugins \
    PYTHONDONTWRITEBYTECODE=1


# Install exiftool for the pelican-image-process plugin, or else our
# photos will lose their EXIF orientation data. libgcc and openssl are
# needed by the stork binary we'll copy in later.
RUN apk add --no-cache exiftool libgcc openssl


WORKDIR /pelican

# Install pelican and available plugins
COPY requirements.txt .
RUN pip3 install -r requirements.txt

# Copy git-based plugins
COPY --from=PLUGINS /pelican/plugins/ ./plugins/

# Copy and install theme
COPY --from=BUILD /build/static/ ./inelegant/static/
COPY --from=STORK /stork/stork.wasm ./inelegant/static/
COPY static/ ./inelegant/static/
COPY templates/ ./inelegant/templates/
RUN pelican-themes -i inelegant && rm -rf inelegant


# Fetch the stork binary, which is needed for the pelican-search
# plugin
COPY --from=STORK /stork/bin/stork /usr/bin/stork


# This script enables the github action to produce outputs reflecting
# the settings used
COPY entrypoint.py /pelican/entrypoint.py

# launch this container with the site checkout mounted as /work
WORKDIR /work
ENTRYPOINT ["/pelican/entrypoint.py"]
CMD []


# The end.
