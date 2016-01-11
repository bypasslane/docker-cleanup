#!/bin/bash

SOCKET=${DOCKER_SOCKET:-/var/run/docker.sock}
DOCKER=${DOCKER_BIN:-/usr/local/bin/docker}
DEBUG=${DEBUG:-0}
EXEMPT="${EXEMPT_IMAGES} bypass/docker-cleanup:latest"
DELAY=${DELAY:-3600}

die() {
    echo "[ERROR] $1"
    exit -1
}

info() {
    echo "[INFO] $1"
}

[ -e "${SOCKET}" ] || die "Socket not found: ${SOCKET}"
[ -e "${DOCKER}" ] || die "File not found: ${DOCKER}"

RUNNING_IMAGES=$(${DOCKER} ps | grep -v NAMES| awk '{ print $2 }' | sort -n | uniq)
AVAIL_IMAGES=$(${DOCKER} images | grep -v REPOSITORY | grep -v '<none>' | \
    awk 'BEGIN { OFS=":" } { print $1,$2 }' | sort -n | uniq)

while true; do
    DATE=$(date +"%D %T")
    echo "[START] ${DATE}"
    for IMG in $AVAIL_IMAGES; do
        CONTAINERS=$(${DOCKER} ps -a --filter ancestor=${IMG} | grep -v NAMES | awk '{ print $1 }')
        if [[ "$RUNNING_IMAGES" =~ "$IMG" ]]; then
            if [ $DEBUG -gt 0 ]; then
                info "The following containers are running from ${IMG}"
                info "${CONTAINERS}"
            fi
        else
            if [ $DEBUG -gt 0 ]; then
                info "$IMG is not running"
            else
                for CONTAINER in ${CONTAINERS}; do
                    info "Removing container ${CONTAINER}"
                    docker rm ${CONTAINER}
                done
                if [[ ! "${EXEMPT}" =~ "${IMG}" ]]; then
                    info "Removing image ${IMG}"
                    docker rmi ${IMG}
                else
                    info "Not removing exempt image ${IMG}"
                fi
            fi
        fi
    done
    
    DATE=$(date +"%D %T")
    echo "[END] ${DATE}"
    
    sleep ${DELAY}
done
