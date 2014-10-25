#!/usr/bin/env bash
set -e

status() {
  echo -e "\e[36m  > $*\e[m"
}

indent() {
  c='s/^/    /'
  case $(uname) in
    Darwin) sed -l "$c";; # mac/bsd sed: -l buffers on line boundaries
    *)      sed -u "$c";; # unix/gnu sed: -u unbuffered (arbitrary) chunks of data
  esac
}

status "Get dependencies"
pub get | indent

status "Analyzing codebase with dartanalyzer"
dartanalyzer --package-warnings bin/index.dart | indent
dartanalyzer --package-warnings bin/game.isolate.dart | indent
dartanalyzer --package-warnings web/*.dart | indent
dartanalyzer --package-warnings test/all.dart | indent

status "Start tests"
dart --checked test/all.dart
