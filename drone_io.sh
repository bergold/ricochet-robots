#!/usr/bin/env bash
set -o pipefail
set -e

cRed='\e[31m'
cGreen='\e[32m'
cYellow='\e[33m'
cCyan='\e[36m'
cReset='\e[m'

status() {
  echo -e "\n${cCyan}  > $*${cReset}"
}

finish() {
  echo -e "\n${cRed}  > Finished with $?${cReset}\n"
}
trap finish EXIT

indent() {
  c='s/^/    /'
  sed -u "$c"
}

echo "$BASH_VERSION" | indent

status "Get dependencies"
pub get | indent

status "Analyzing codebase with dartanalyzer"
dartanalyzer lib/*.dart | indent
dartanalyzer bin/index.dart | indent
dartanalyzer bin/game.isolate.dart | indent
dartanalyzer web/*.dart | indent
dartanalyzer test/all.dart | indent

status "Start tests"
dart --checked test/all.dart | indent
