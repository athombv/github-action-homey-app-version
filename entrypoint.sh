#!/bin/sh -l

cd /github/workspace/

npx homey app version "$1" --changelog "$2"

echo "version=$(cat app.json | jq --raw-output .version)" >> $GITHUB_OUTPUT