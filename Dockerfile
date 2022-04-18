FROM debian:bullseye-slim

ARG VERSION=3ac924c1c79aeace003623c1fdf96bceeed563ae
ARG REPOSITORY=https://github.com/cenk1cenk2/gitlab-tools.git
ARG S6_VERSION=2.2.0.3

WORKDIR /opt/gitlab-tools

SHELL ["/bin/bash", "-c"]

# Install s6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / && \
  # create directories
  mkdir -p /etc/services.d && mkdir -p /etc/cont-init.d && mkdir -p /s6-bin && \
  rm -rf /tmp/*

RUN \
  # add build time dependencies
  apt-get update && apt-get install -y curl gnupg apt-transport-https git && \
  curl -fsSL https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc | apt-key add - && \
  apt-get update && \
  apt-get install -y python3-virtualenv virtualenv rabbitmq-server redis-server build-essential python3-dev libpq-dev git postgresql-server-dev-all python3-pip libffi-dev nginx uwsgi uwsgi-plugin-python3 && \
  # clone the dependencies
  mkdir -p /opt/gitlab-tools /etc/gitlab-tools /data && \
  git clone ${REPOSITORY} . && \
  git checkout ${VERSION} && \
  curl -fsSL https://deb.nodesource.com/setup_12.x | bash - && \
  apt-get install -y nodejs && \
  cd /opt/gitlab-tools/gitlab_tools/static && npm ci && \
  # clean up build time dependencies
  apt-get remove -y curl gnupg apt-transport-https nodejs

RUN \
  virtualenv -p python3 venv && \
  source ./venv/bin/activate && \
  pip install --no-cache-dir --upgrade wheel setuptools && \
  pip install --no-cache-dir .

COPY ./hostfs /

# Create default configuration folders
RUN mkdir -p /scripts

# Copy scripts
ADD https://gist.githubusercontent.com/cenk1cenk2/e03d8610534a9c78f755c1c1ed93a293/raw/logger.sh /scripts/logger.sh
ADD https://gist.githubusercontent.com/cenk1cenk2/439be02da4533525e5384f90d1873aac/raw/variable-initiate.sh /scripts/variable-initiate.sh

# Move s6 supervisor files inside the container
RUN  \
  chmod +x /scripts/*.sh && \
  chmod +x /etc/cont-init.d/*.sh && \
  chmod +x /etc/services.d/gitlab-tools-bgtask/* && \
  chmod +x /etc/services.d/gitlab-tools-worker/* && \
  chmod +x /etc/services.d/uwsgi/*

RUN useradd -ms /bin/bash -u 900 service

RUN mkdir -p /home/service/.ssh/ && \
  chown -R service:service /home/service

VOLUME [ "/home/service" ]
EXPOSE 80

# s6 behaviour, https://github.com/just-containers/s6-overlay
ENV S6_KEEP_ENV 1
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS 2
ENV S6_FIX_ATTRS_HIDDEN 1

ENTRYPOINT [ "/init" ]
