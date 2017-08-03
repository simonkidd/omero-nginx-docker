FROM openmicroscopy/omero-web
MAINTAINER douglas_russell@hms.harvard.edu

ARG PYTHONPATH=/opt/omero/web/venv/lib/python2.7/site-packages/:/opt/omero/web/OMERO.web/lib/python/

# Generate config is only possible because this image is forced to use
# openmicroscopy/omero-web as a base, but might as well.
# It also can not be generated as root so do so before the user switch
RUN /opt/omero/web/OMERO.web/bin/omero web config nginx > /opt/omero/web/nginx_omero-web.conf

USER root

RUN yum -y install nginx \
    && sed -i.bak -re 's/( default_server.*)/; #\1/' /etc/nginx/nginx.conf \
    && mv /opt/omero/web/nginx_omero-web.conf /etc/nginx/conf.d/omero-web.conf \
    && chown root:root /etc/nginx/conf.d/omero-web.conf \
    && python /opt/omero/web/OMERO.web/lib/python/omeroweb/manage.py collectstatic --noinput

ADD entrypoint.sh /usr/local/bin/entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
