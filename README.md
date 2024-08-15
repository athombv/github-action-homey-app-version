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
name: Update Homey App Version
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
      name: Update Homey App Version
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v4
        
        - name: Update Homey App Version
          uses: athombv/github-action-homey-app-version@master
          id: update_app_version
          with:
            version: ${{ inputs.version }}
            changelog: ${{ inputs.changelog }}

        - name: Commit & Push
          run: |
            git config --local user.name "github-actions[bot]"
            git config --local user.email "41898282+github-actions[bot]@users.noreply.github.com"

            git add -A
            git commit -m "Update Homey App Version to v${{ steps.update_app_version.outputs.version }}"
            git tag "v${{ steps.update_app_version.outputs.version }}"

            git push origin HEAD --tags
```
