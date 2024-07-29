#!/bin/sh -l

set -e

cd /github/workspace/

npm ci --ignore-scripts
npx homey app version "$1" --changelog "$2"

echo "version=$(cat app.json | jq --raw-output .version)" >> $GITHUB_OUTPUT
