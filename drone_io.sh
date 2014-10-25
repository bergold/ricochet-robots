#!/usr/bin/env bash
set -o pipefail
set -e

CRED='31'
CGREEN='32'
CYELLOW='33'
CCYAN='36'

status() {
  echo -e "\n\e[$CCYANm  > $*\e[m"
}

finish() {
  echo -e "\n\e[$CREDm  > Finished with $?\e[m\n"
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
