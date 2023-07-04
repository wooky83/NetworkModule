#!/bin/bash -e

readonly notice_color=$'\033[0;32m' # green
readonly no_color=$'\033[0m'

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

echo "${notice_color}[Generating projects]${no_color}"

tuist clean
tuist fetch
tuist generate
