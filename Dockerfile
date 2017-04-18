FROM buildpack-deps:jessie

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
org.label-schema.name="primo-explore-devenv" \
org.label-schema.description="Primo New UI Customization Docker Development Environment" \
org.label-schema.vcs-ref=$VCS_REF \
org.label-schema.vcs-url="https://github.com/thatbudakguy/primo-explore-devenv-docker" \
org.label-schema.vendor="WatzekDigitalInitiatives" \
org.label-schema.version=$VERSION \
org.label-schema.schema-version="1.0"

RUN groupadd --gid 1000 node \
    && useradd --uid 1000 --gid node --shell /bin/bash --create-home node

# gpg keys listed at https://github.com/nodejs/node#release-team
RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    56730D5401028683275BD23C23EFEFE93C4CFFFE \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --keyserver keyserver.pgp.com --recv-keys "$key" ; \
  done

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 4.2.6
ENV NPM_VERSION 3.3.12
ENV PROXY_SERVER http://alliance-primo-sb.hosted.exlibrisgroup.com:80
ENV VIEW VIEW_CODE

RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs

RUN npm install npm@${NPM_VERSION} -g
RUN npm install -g gulp

RUN cd /home/node && \
    git clone https://github.com/ExLibrisGroup/primo-explore-devenv.git
RUN cd /home/node/primo-explore-devenv && \
    npm install
RUN cd /home/node/primo-explore-devenv/primo-explore/custom && \
    git clone https://github.com/ExLibrisGroup/primo-explore-package.git
RUN sed -ie 's@http:\/\/your-server:your-port@'"$PROXY_SERVER"'@g' /home/node/primo-explore-devenv/gulp/config.js

WORKDIR /home/node/primo-explore-devenv

EXPOSE 8003
EXPOSE 3001

CMD [ "/bin/bash", "-c", "gulp run --view $VIEW" ]
