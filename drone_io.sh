#!/usr/bin/env bash
set -o pipefail
set -e

cRed='\e[0;31m'
cGreen='\e[0;32m'
cYellow='\e[0;33m'
cCyan='\e[0;36m'
cReset='\e[0m'

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
