FROM node:boron

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

ENV NPM_VERSION 3.3.12
ENV PROXY_SERVER http://alliance-primo-sb.hosted.exlibrisgroup.com:80
ENV VIEW VIEW_CODE

RUN npm install npm@${NPM_VERSION} -g
RUN npm install -g protractor gulp

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
