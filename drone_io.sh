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
  case $? in
    0)
      echo -e "\n${cGreen}Finished successfully [0]${cReset}\n";;
    1)
      echo -e "\n${cYellow}Finished with warning [1]${cReset}\n";;
    *)
      echo -e "\n${cGreen}Finished with error [$?]${cReset}\n";;
  esac
  exit $?
}
trap finish EXIT

indent() {
  c='s/^/    /'
  sed -u "$c"
}

echo ""
echo "running bash v$BASH_VERSION"

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
