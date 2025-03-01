#!/bin/bash

token=$(curl -X POST -H "Authorization: token $ACCESS_TOKEN" -H "Accept: application/vnd.github+json" https://api.github.com/repos/${REPO}/actions/runners/registration-token | jq .token --raw-output)

cd /home/docker/actions-runner

./config.sh --url https://github.com/$REPO --token $token --labels test

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token $token
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!