FROM arti.hpc.amslabs.hpecorp.net/third-party-docker-stable-local/nginx:1.18.0-alpine AS base

# Setup for building portal
RUN mkdir /tmp/workdir
COPY . /tmp/workdir
RUN rm -fr /tmp/workdir/portal/node_modules

COPY pip.conf /etc

RUN echo -e "https://arti.hpc.amslabs.hpecorp.net/artifactory/mirror-alpine/v3.11/main\nhttps://arti.hpc.amslabs.hpecorp.net/artifactory/mirror-alpine/v3.11/community" > /etc/apk/repositories && \
    apk update && \
    apk add --no-cache yarn git make python3 python3-dev rpm && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && rm -r /root/.cache

# Build portal
FROM base AS build
RUN cd /tmp/workdir/docs/portal/developer-portal;make VERSIONED_MD=Y NOEDITLINKS=Y md
RUN cd /tmp/workdir/docs/portal/developer-portal;rm -fr install operations overview
RUN cd /tmp/workdir/docs/portal;yarn install;yarn config set network-timeout 300000;yarn build

# Only copy the good stuff
FROM arti.hpc.amslabs.hpecorp.net/third-party-docker-stable-local/nginx:1.18.0-alpine AS application
COPY --from=build /tmp/workdir/portal/public /usr/share/nginx/html
