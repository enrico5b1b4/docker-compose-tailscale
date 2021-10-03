#!/bin/bash

source ./secrets/tailscale.env

mkdir -p ./user1home
docker-compose build
