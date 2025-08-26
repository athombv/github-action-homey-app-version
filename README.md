# Homey App Version

This GitHub Action will update the version of the current Homey app.

## Inputs

### version
Version. Can be either `major`, `minor`, `patch`, or a semver version.

### changelog
Changelog of the new version in English.

### changelog_xx
Changelog of the new version in ISO specific language.


## Outputs

### version
The new version in SemVer format.

## Example usage

### Basic usage with single language (backward compatible)
```yaml
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

# Needed in order to push the commit and create a release
permissions:
  contents: write

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
            gh release create "v${{ steps.update_app_version.outputs.version }}" -t "v${{ steps.update_app_version.outputs.version }}" --notes "" --generate-notes
          env:
            GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
            GH_TOKEN: ${{ github.token }}
```

### Multi-language changelog usage
```yaml
name: Update Homey App Version with Multi-language Changelog
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
      changelog_no:
        type: string
        description: Changelog in Norwegian
        required: false
      changelog_en:
        type: string
        description: Changelog in English
        required: false
      changelog_sv:
        type: string
        description: Changelog in Swedish
        required: false

permissions:
  contents: write

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
            changelog_no: ${{ inputs.changelog_no }}
            changelog_en: ${{ inputs.changelog_en }}
            changelog_sv: ${{ inputs.changelog_sv }}

        - name: Commit & Push
          run: |
            git config --local user.name "github-actions[bot]"
            git config --local user.email "41898282+github-actions[bot]@users.noreply.github.com"

            git add -A
            git commit -m "Update Homey App Version to v${{ steps.update_app_version.outputs.version }}"
            git tag "v${{ steps.update_app_version.outputs.version }}"

            git push origin HEAD --tags
            gh release create "v${{ steps.update_app_version.outputs.version }}" -t "v${{ steps.update_app_version.outputs.version }}" --notes "" --generate-notes
          env:
            GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
            GH_TOKEN: ${{ github.token }}
```

## Notes

- The action supports changelog languages from the set of allowed langages in homey-cli
- You can provide changelog for any combination of these languages
- If no language-specific changelog is provided, the action will fall back to the legacy `changelog` input for backward compatibility
- The action will automatically build the appropriate `homey app version` command with the `--changelog.{language}` flags for each provided language
