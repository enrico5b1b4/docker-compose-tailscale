#!/bin/bash

# orchestrating x11docker docker-compose
# https://github.com/mviereck/x11docker/issues/227

x11docker --cleanup

source ./secrets/tailscale.env

mkdir -p ./user1home
read Xenv < <(x11docker --nxagent --showenv --quiet)
echo $Xenv
export $Xenv

docker-compose up --remove-orphans

x11docker --cleanup
