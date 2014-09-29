#!/usr/bin/env bash
set -o xtrace
set -e

diranalyzer() {
  set +o xtrace
  for f in $@
  do
    
    if [[ $f == *.part.dart ]]
    then
      continue
    fi
    
    dartanalyzer $f
  done
  set -o xtrace
}

# get dependencies
pub get

# ensure the generated code is warning free
diranalyzer lib/*.dart
diranalyzer bin/*.dart
diranalyzer web/*.dart
diranalyzer test/*.dart

# run tests
dart --checked test/all.dart
