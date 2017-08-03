Nginx for OMERO.web Docker
==========================

An OMERO.web (and thus CentOS 7) based Docker image for Nginx.


Running the image
-----------------

To run the Docker image you can set a single OMERO.server to connect to by defining `MASTER_ADDR`:

    docker run -d --name omero-nginx \
        -e OMEROWEBHOST=omero-web.example.org \
        -p 8080:80 \
        dpwrussell/omero-nginx


Exposed ports
-------------

- 80
