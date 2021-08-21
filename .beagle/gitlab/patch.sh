#!/bin/bash
set -e

if [[ -d ".beagle/gitlab/assets/build/patches" ]]; then
  echo "Applying patches for gitlab-foss..."
  git apply --ignore-whitespace < .beagle/gitlab/assets/build/patches/*.patch
fi
