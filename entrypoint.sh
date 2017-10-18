#!/usr/bin/env /bin/bash

set -eu

OMEROWEBHOST=${OMEROWEBHOST:-web}
OMERO_MS_THUMBNAIL_BACKEND_HOST=${OMERO_MS_THUMBNAIL_BACKEND_HOST:-}
OMERO_MS_IMAGE_REGION_BACKEND_HOST=${OMERO_MS_IMAGE_REGION_BACKEND_HOST:-}

sed -i -re "s/(server )[a-zA-Z0-9][a-zA-Z0-9.-]*[a-zA-Z0-9](:4080 fail_timeout=0;)/\1$OMEROWEBHOST\2/" /etc/nginx/conf.d/omero-web.conf
sed -i -re 's/warn/debug/' /etc/nginx/nginx.conf

if [ -n "$OMERO_MS_THUMBNAIL_BACKEND_HOST" ]; then
  sed -i -re "s/(server )[a-zA-Z0-9][a-zA-Z0-9.-]*[a-zA-Z0-9](:8080 fail_timeout=0 max_fails=0;)/\1$OMERO_MS_THUMBNAIL_BACKEND_HOST\2/" /etc/nginx/ms-thumbnails_upstream.conf

  grep -v 'include /etc/nginx/ms-thumbnails_upstream.conf;' /etc/nginx/conf.d/omero-web.conf \
  && sed -i '
  /upstream omeroweb {/ i\
include /etc/nginx/ms-thumbnails_upstream.conf;
  ' /etc/nginx/conf.d/omero-web.conf

  grep -v 'include /etc/nginx/ms-thumbnails_locations.conf;' /etc/nginx/conf.d/omero-web.conf \
  && sed -i '
  /location \/ {/ i\
    include /etc/nginx/ms-thumbnails_locations.conf;
  ' /etc/nginx/conf.d/omero-web.conf
fi

if [ -n "$OMERO_MS_IMAGE_REGION_BACKEND_HOST" ]; then
  sed -i -re "s/(server )[a-zA-Z0-9][a-zA-Z0-9.-]*[a-zA-Z0-9](:8080 fail_timeout=0 max_fails=0;)/\1$OMERO_MS_IMAGE_REGION_BACKEND_HOST\2/" /etc/nginx/ms-image-region_upstream.conf

  grep -v 'include /etc/nginx/ms-image-region_upstream.conf;' /etc/nginx/conf.d/omero-web.conf \
  && sed -i '
  /upstream omeroweb {/ i\
include /etc/nginx/ms-image-region_upstream.conf;
  ' /etc/nginx/conf.d/omero-web.conf

  grep -v 'include /etc/nginx/ms-image-region_locations.conf;' /etc/nginx/conf.d/omero-web.conf \
  && sed -i '
  /location \/ {/ i\
    include /etc/nginx/ms-image-region_locations.conf;
  ' /etc/nginx/conf.d/omero-web.conf
fi

nginx -g 'daemon off;'
