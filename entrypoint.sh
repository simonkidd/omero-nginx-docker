#!/usr/bin/env /bin/bash

set -e

OMEROWEBHOST=${OMEROWEBHOST:-web}

sed -i -re "s/(server )[a-zA-Z0-9][a-zA-Z0-9.-]*[a-zA-Z0-9](:4080 fail_timeout=0;)/\1$OMEROWEBHOST\2/" /etc/nginx/conf.d/omero-web.conf

nginx -g 'daemon off;'
