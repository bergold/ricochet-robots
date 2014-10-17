#!/usr/bin/env bash
set -e

status() {
  echo -e "\[\e[36m\]> $*\[\e[m\]"
}

indent() {
  c='s/^/    /'
  case $(uname) in
    Darwin) sed -l "$c";; # mac/bsd sed: -l buffers on line boundaries
    *)      sed -u "$c";; # unix/gnu sed: -u unbuffered (arbitrary) chunks of data
  esac
}

status "get dependencies"
pub get | indent

status "analyzing codebase with dartanalyzer"
dartanalyzer lib/*.dart | indent
dartanalyzer bin/index.dart | indent
dartanalyzer web/*.dart | indent
dartanalyzer test/all.dart | indent

status "start tests"
dart --checked test/all.dart | indent
