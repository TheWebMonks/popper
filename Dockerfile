# Install chromium in Docker
# https://github.com/GoogleChrome/puppeteer/blob/master/docs/troubleshooting.md#running-on-alpine
#
FROM node:8.12.0-alpine

ARG ROOT=/popper-app

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
#ENV CHROME_BIN="/usr/bin/chromium-browser"
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

# Installs latest Chromium (68) package.
RUN apk update && apk upgrade && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories && \
    apk add --no-cache \
      chromium@edge \
      nss@edge \
      bash

# Define the source workdir
WORKDIR ${ROOT}

# Expose port 3000
EXPOSE 3000

# Install npm libs
COPY package.json .
RUN npm install

# Define entrypoint
COPY deployment/entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Default command
CMD ["bash"]

COPY src/ ${ROOT}/src/
