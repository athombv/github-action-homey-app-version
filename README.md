# Homey App Version

This GitHub Action will update the version of the current Homey app.

## Inputs

## version

Version. Can be either `major`, `minor`, `patch`, or a semver version.

## Outputs

## version

The new version in SemVer format.

## changelog

Changelog of the new version in English.

## Example usage

```name: Update Homey App Version

on:
  workflow_dispatch:
    inputs:
      version:
        type: choice
        description: Version
        required: true
        default: patch
        options:
          - major
          - minor
          - patch
      changelog:
        type: string
        description: Changelog
        required: true

jobs:  
    main:
      name: Update App Version
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v3
        
        - name: Update App Version
          uses: athombv/github-action-homey-app-version@master
          id: update_app_version
          with:
            version: ${{ inputs.version }}
            changelog: ${{ inputs.changelog }}

        - name: Commit & Push
          run: |
            git config --local user.email "sysadmin+githubactions@athom.com"
            git config --local user.name "Homey Github Actions Bot"

            git add -A
            git commit -m "Update Homey App Version to v${{ steps.update_app_version.outputs.version }}"
            git tag "v${{ steps.update_app_version.outputs.version }}"

            git push origin HEAD --tags
```