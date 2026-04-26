#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

if [[ -f .env.play ]]; then
  set -a
  # shellcheck disable=SC1091
  source .env.play
  set +a
fi

export FL_PACKAGE_NAME="${FL_PACKAGE_NAME:-br.com.wsilva.tasko.go}"
export FL_TRACK="${FL_TRACK:-internal}"
export FL_AAB_PATH="${FL_AAB_PATH:-build/app/outputs/bundle/release/app-release.aab}"
export FL_SKIP_BUILD="${FL_SKIP_BUILD:-0}"

require_command() {
  local command_name="$1"

  if ! command -v "$command_name" >/dev/null 2>&1; then
    printf 'Missing required command: %s\n' "$command_name" >&2
    exit 1
  fi
}

require_file() {
  local file_path="$1"
  local description="$2"

  if [[ ! -f "$file_path" ]]; then
    printf 'Missing %s: %s\n' "$description" "$file_path" >&2
    exit 1
  fi
}

require_env() {
  local variable_name="$1"

  if [[ -z "${!variable_name:-}" ]]; then
    printf 'Missing required environment variable: %s\n' "$variable_name" >&2
    exit 1
  fi
}

should_skip_build() {
  case "${FL_SKIP_BUILD}" in
    1|true|TRUE|True)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

require_command flutter
require_command fastlane
require_file "android/key.properties" "Android signing properties"

require_env FL_SERVICE_ACCOUNT_PATH
require_file "$FL_SERVICE_ACCOUNT_PATH" "Google Play service account JSON"

if ! should_skip_build; then
  printf 'Resolving Flutter dependencies...\n'
  flutter pub get

  printf 'Building signed Android App Bundle...\n'
  flutter build appbundle --release
fi

require_file "$FL_AAB_PATH" "Android App Bundle"

printf 'Uploading %s\n' "$(basename "$FL_AAB_PATH")"
printf 'Package: %s\n' "$FL_PACKAGE_NAME"
printf 'Track: %s\n' "$FL_TRACK"

fastlane android upload_internal

printf 'Upload submitted to Google Play track %s. Check Play Console processing status.\n' "$FL_TRACK"