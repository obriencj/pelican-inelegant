FROM python:3.9


# Need this for the pelican-image-process plugin
RUN apt-get update ; apt-get install -y exiftool


# Install pelican and available plugins
RUN pip3 install \
  pelican[markdown] \
  pelican-image-process pelican-liquid-tags pelican-yaml-metadata \
  pygments


WORKDIR /pelican


# Fetch git plugins
ENV PLUGIN_PATHS=/pelican/plugins
RUN git clone \
  https://github.com/getpelican/pelican-plugins.git /pelican/plugins


# Fetch and install theme
COPY static/ /pelican/inelegant/static/
COPY templates/ /pelican/inelegant/templates/
RUN pelican-themes -i /pelican/inelegant


WORKDIR /work

ENV PYTHONDONTWRITEBYTECODE=1
ENTRYPOINT ["pelican"]
CMD []


# The end.
