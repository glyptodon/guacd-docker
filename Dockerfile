#
# Copyright (C) 2015 Glyptodon LLC
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

#
# Dockerfile for guacamole-server
#

# Start from CentOS base image
FROM centos:centos7
MAINTAINER Michael Jumper <mike.jumper@guac-dev.org>

# Version info
ENV GUAC_VERSION 0.9.6

# Bring environment up-to-date
RUN yum -y update
RUN yum -y install epel-release

# Install guacamole-server build dependencies
RUN yum -y install        \
    cairo-devel           \
    freerdp-devel         \
    gcc                   \
    libssh2-devel         \
    libtelnet-devel       \
    libvorbis-devel       \
    libvncserver-devel    \
    make                  \
    pango-devel           \
    pulseaudio-libs-devel \
    tar                   \
    uuid-devel

# Clean up after yum
RUN yum clean all

# Download latest guacamole-server
RUN curl -L \
    http://sourceforge.net/projects/guacamole/files/current/source/guacamole-server-$GUAC_VERSION.tar.gz \
    > /tmp/guacamole-server-$GUAC_VERSION.tar.gz

# Build guacamole-server
RUN \
     cd /tmp                                                   && \
     tar -xzf guacamole-server-$GUAC_VERSION.tar.gz            && \
     cd guacamole-server-$GUAC_VERSION                         && \
     ./configure                                               && \
     make                                                      && \
     make install                                              && \
     ldconfig

# Remove build after install is complete
RUN rm -Rf /tmp/guacamole-server*

# Start guacd, listening on port 0.0.0.0:4822
EXPOSE 4822
CMD [ "/usr/local/sbin/guacd", "-b", "0.0.0.0", "-f" ]

