# Multi-stage Containerfile for building the pelican-inelegant
# container, as used by the pelican-inelegant github action.


# pelican-inelegant inherits some node dependencies from the original
# elegant theme. In order to produce the final CSS and minified JS,
# we'll use a node container

FROM node:20 AS BUILD

WORKDIR /build

COPY package.json yarn.lock .
RUN yarnpkg

COPY gulpfile.babel.js .
COPY source/ /build/source/
RUN npx gulp


# pelican-inelegant includes a selection of plugins pre-installed.
# These are the git-based pelican plugins. We won't have git available
# in the final container, so let's use a stage just to fetch and prune
# the plugins git repository. Note that we're not using ADD as
# currently buildah doesn't support git refs

FROM ubuntu:latest AS PLUGINS

WORKDIR /pelican

RUN apt-get update && apt-get install -y git && \
  git clone --depth=1 --single-branch --branch master --no-tags \
  https://github.com/getpelican/pelican-plugins.git /pelican/plugins

# We installed these plugins via requirements.txt, and don't want
# these old copies to interfere
RUN rm -rf /pelican/plugins/.git \
           /pelican/plugins/image_process \
           /pelican/plugins/liquid_tags \
           /pelican/plugins/series


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


# Need exiftool for the pelican-image-process plugin, or else our photos
# will lose their EXIF orientation data. We need git to pull down the
# plugins repo
RUN apk add --no-cache exiftool


WORKDIR /pelican

# Install pelican and available plugins
COPY requirements.txt .
RUN pip3 install -r requirements.txt

# Copy git-based plugins
COPY --from=PLUGINS /pelican/plugins/ ./plugins/

# Copy and install theme
COPY --from=BUILD /build/static/ ./inelegant/static/
COPY static/ ./inelegant/static/
COPY templates/ ./inelegant/templates/
RUN pelican-themes -i inelegant && rm -rf inelegant

# This script enables the github action to produce outputs reflecting
# the settings used
COPY entrypoint.py .


# launch this container with the site checkout mounted as /work
WORKDIR /work
ENTRYPOINT ["/pelican/entrypoint.py"]
CMD []


# The end.
