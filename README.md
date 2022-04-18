# docker-gitlab-tools

[![pipeline status](https://gitlab.kilic.dev/docker/gitlab-tools/badges/main/pipeline.svg)](https://gitlab.kilic.dev/docker/gitlab-tools/-/commits/main) [![Docker Pulls](https://img.shields.io/docker/pulls/cenk1cenk2/gitlab-tools)](https://hub.docker.com/repository/docker/cenk1cenk2/gitlab-tools) [![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/cenk1cenk2/gitlab-tools)](https://hub.docker.com/repository/docker/cenk1cenk2/gitlab-tools) [![Docker Image Version (latest by date)](https://img.shields.io/docker/v/cenk1cenk2/gitlab-tools)](https://hub.docker.com/repository/docker/cenk1cenk2/gitlab-tools) [![GitHub last commit](https://img.shields.io/github/last-commit/cenk1cenk2/docker-gitlab-tools)](https://github.com/cenk1cenk2/docker-gitlab-tools)

## Description

This is the containerized version of the [gitlab-tools](https://github.com/Salamek/gitlab-tools). [gitlab-tools](https://github.com/Salamek/gitlab-tools) enables you to synchronize repositories between different `git` servers.

The container itself includes everything that is required to run the [gitlab-tools](https://github.com/Salamek/gitlab-tools) like the RabbitMQ and Redis instances, a UWSGI server to host the flask application, and an Nginx instance to stay in front of it. The only complementary container required to run the application is the database.

<!-- toc -->

- [Setup](#setup)
  - [Environment Variables](#environment-variables)
  - [Persistent Storage](#persistent-storage)

<!-- tocstop -->

## Setup

You can run this application as a `docker-compose` stack. The image is hosted as `cenk1cenk2/gitlab-tools` on DockerHub. Check out the [docker-compose](./docker-compose.yml) file for example configuration.

### Environment Variables

You can pass the [gitlab-tools](https://github.com/Salamek/gitlab-tools) configuration directly through environment variables without the need to run the CLI itself.

| Variable             | Description                                                                                                                                        |
| -------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| LOG_LEVEL            | Sets the log level for the container. Can take values of "silent", "error", "warn", "lifetime", "info", "debug"                                    |
| GT_GITLAB_APP_ID     | Your application id for your Gitlab instance.                                                                                                      |
| GT_GITLAB_APP_SECRET | Your application secret for your Gitlab instance.                                                                                                  |
| GT_GITLAB_URL        | Your URL pointing to your Gitlab instance.                                                                                                         |
| GT_SERVER_NAME       | Outward-facing URI of where this application will be hosted.                                                                                       |
| GT_SECRET_KEY        | Secret key for session storage.                                                                                                                    |
| GT_DATABASE_URI      | Full URL for SQLAlchemy to connect to the database. Should be in the format of: "postgresql://gitlab-tools:something@gitlab-tools-db/gitlab-tools" |

### Persistent Storage

[gitlab-tools](https://github.com/Salamek/gitlab-tools) uses the disk for storing data of SSH keys as well as the repositories themselves. The container runs the application under an unprivileged user called `service` and [gitlab-tools](https://github.com/Salamek/gitlab-tools) uses the user home directory for the storage.

So to make this application work properly please mount a volume to `/home/service` to store the data persistently.
