# syntax=docker/dockerfile-upstream:master-labs
FROM cenk1cenk2/vizier:latest AS vizier

FROM debian:bullseye-slim

ARG VERSION=1.4.6
ARG REPOSITORY=https://github.com/Salamek/gitlab-tools.git
ARG NODE_VERSION=16

WORKDIR /opt/gitlab-tools

SHELL ["/bin/bash", "-c"]


RUN \
  apt-get update && apt-get install -y curl gnupg apt-transport-https git && \
  # add build time dependencies
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor | apt-key add - && \
  echo "deb https://deb.nodesource.com/node_${NODE_VERSION}.x nodistro main" > /etc/apt/sources.list.d/nodesource.list  && \
  apt-get update && \
  apt-get install -y tini python3-virtualenv virtualenv build-essential python3-dev libpq-dev git postgresql-server-dev-all python3-pip libffi-dev nginx uwsgi uwsgi-plugin-python3 nodejs && \
  # clone the dependencies
  mkdir -p /opt/gitlab-tools /etc/gitlab-tools /data && \
  git clone ${REPOSITORY} . && \
  git checkout ${VERSION} && \
  cd /opt/gitlab-tools/gitlab_tools/static && \
  npm ci && \
  cd /opt/gitlab-tools && \
  # clean up build time dependencies
  apt-get remove -y curl gnupg apt-transport-https nodejs

RUN \
  virtualenv -p python3 venv && \
  source ./venv/bin/activate && \
  # pip install --no-cache-dir --upgrade wheel setuptools && \
  pip install --no-cache-dir SQLAlchemy==1.4 && \
  pip install --no-cache-dir .

COPY ./hostfs /
COPY --from=vizier /usr/bin/vizier /usr/bin/vizier

RUN useradd -ms /bin/bash -u 900 service

RUN mkdir -p /home/service/.ssh/ && \
  chown -R service:service /home/service

VOLUME [ "/home/service" ]
EXPOSE 80

ENTRYPOINT [ "tini", "--", "vizier", "--config", "/etc/vizier.yml" ]
