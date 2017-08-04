Nginx for OMERO.web Docker
==========================

An OMERO.web (and thus CentOS 7) based Docker image for Nginx.


Running the image
-----------------

To run the Docker image you can set a single OMERO.server to connect to by defining `MASTER_ADDR`:

    docker run -d --name dpwrussell/omero-nginx \
        -e OMEROWEBHOST=omero-web.example.org \
        -p 8080:80 \
        dpwrussell/omero-nginx


Exposed ports
-------------

- 80


Building the image
------------------

To build the docker image a docker version of 17.05+ is required because of the
introduction of multi-stage docker builds.

    docker build . -t dpwrussell/omero-nginx
