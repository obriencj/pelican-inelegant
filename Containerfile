FROM python:3.9


LABEL \
  org.label-schema.schema-version = "1.0" \
  org.label-schema.url = "https://github.com/obriencj/pelican-inelegant" \
  org.label-schema.vcs-url = "https://github.com/obriencj/pelican-inelegant" \
  org.label-schema.description = "InElegant themed Pelican site generator" \
  org.label-schema.name = "pelican-inelegant" \
  org.label-schema.version = "1.0.0"


# Need this for the pelican-image-process plugin, or else our photos
# will lose their EXIF orientation data
RUN apt-get update ; apt-get install -y exiftool


# Install pelican and available plugins
RUN pip3 install \
  pelican[markdown] \
  pelican-image-process pelican-liquid-tags pelican-yaml-metadata \
  pygments


WORKDIR /pelican


# Fetch the pelican-plugins git repository
ENV PLUGIN_PATHS=/pelican/plugins
RUN git clone \
  https://github.com/getpelican/pelican-plugins.git /pelican/plugins


# Copy and install theme
COPY static/ /pelican/inelegant/static/
COPY templates/ /pelican/inelegant/templates/
RUN pelican-themes -i /pelican/inelegant


# since Pelican configurations are loaded as python modules, let's
# avoid writing out a __pycache__ every time they're used
ENV PYTHONDONTWRITEBYTECODE=1


# launch this container with the site checkout mounted as /work
WORKDIR /work
ENTRYPOINT ["pelican"]
CMD []


# The end.
