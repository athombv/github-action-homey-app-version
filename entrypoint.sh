#!/bin/sh -l

cd /github/workspace/

npm ci --ignore-scripts
npx homey app version "$1" --changelog "$2"