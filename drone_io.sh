#!/usr/bin/env bash
set -o pipefail
set -e

status() {
  echo -e "\e[36m  > $*\e[m"
}

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

status "Finished with $?"
