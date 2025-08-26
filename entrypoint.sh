#!/bin/sh -l

set -e

cd /github/workspace/

# GitHub Actions automatically sets INPUT_* environment variables
# Get version (required)
VERSION="$INPUT_VERSION"

# Build the homey command with version
HOMEY_CMD="npx homey app version $VERSION"

# Track if we found any language-specific changelogs
FOUND_LANGUAGE_CHANGELOG=false

# Loop through all environment variables and find changelog_* inputs
for var in $(env | grep "^INPUT_CHANGELOG_" | cut -d= -f1); do
    # Get the variable value
    value=$(eval echo \$$var)
    
    # Skip if empty
    if [ -n "$value" ]; then
        # Extract language code from INPUT_CHANGELOG_XX
        lang_code=$(echo "$var" | sed 's/^INPUT_CHANGELOG_//' | tr '[:upper:]' '[:lower:]')
        
        # Add to command
        HOMEY_CMD="$HOMEY_CMD --changelog.$lang_code \"$value\""
        FOUND_LANGUAGE_CHANGELOG=true
    fi
done

# Add legacy changelog if no language-specific ones were found (backward compatibility)
if [ "$FOUND_LANGUAGE_CHANGELOG" = false ] && [ -n "$INPUT_CHANGELOG" ]; then
    HOMEY_CMD="$HOMEY_CMD --changelog \"$INPUT_CHANGELOG\""
fi

# Execute the homey command
eval $HOMEY_CMD

echo "version=$(cat app.json | jq --raw-output .version)" >> $GITHUB_OUTPUT
