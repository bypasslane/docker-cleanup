# Docker Cleanup

This container uses a volume mount to `/var/run/docker.sock` to query for running containers and their
images and does a little cleanup dance.

## Run me!

    docker run -v /var/run/docker.sock:/var/run/docker.sock bypass/docker-cleanup:latest

## Optional Configuration

Some helpful ENV vars you might consider setting, but are not required:

* `DEBUG` - set to 1 for debugging mode, which will NOT commit any actions (default: `0`)
* `SOCKET` - set alternative location for docker.socket (default: `/var/run/docker.sock`)
* `DOCKER` - set alternative location for docker binary (default: `/usr/local/bin/docker`)
* `EXEMPT` - set list of image names to exempt from cleanup
* `DELAY` - set delay between checks (default: `3600`)
