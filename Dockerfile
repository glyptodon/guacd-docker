#
# Guacamole Dockerfile
#

# Start from CentOS base image
FROM centos:centos7
MAINTAINER Michael Jumper <mike.jumper@guac-dev.org>

# Bring environment up-to-date
RUN yum -y update
RUN yum -y install epel-release

# Install guacamole-server build dependencies
RUN yum -y install     \
    autoconf           \
    automake           \
    cairo-devel        \
    freerdp-devel      \
    gcc                \
    git                \
    libssh2-devel      \
    libtelnet-devel    \
    libtool            \
    libvncserver-devel \
    make               \
    pango-devel        \
    uuid-devel

# Clean up after yum
RUN yum clean all

# Download and install latest guacamole-server
RUN \
     cd /tmp                                                   && \
     git clone https://github.com/glyptodon/guacamole-server   && \
     cd guacamole-server                                       && \
     git checkout -b docker-build 0.9.6                        && \
     autoreconf -fi                                            && \
     ./configure                                               && \
     make                                                      && \
     make install                                              && \
     ldconfig

# Remove build after install is complete
RUN rm -Rf /tmp/guacamole-server

# Start guacd, listening on port 4822
RUN /usr/local/sbin/guacd -f
EXPOSE 4822

