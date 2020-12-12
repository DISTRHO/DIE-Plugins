#!/bin/bash

set -e

cd $(dirname "${0}")

if [ ! -d ardour ]; then
  git clone --depth=1 -b master git@github.com:Ardour/ardour.git
fi

pushd ardour
git checkout .
git pull
popd

# TODO use rsync
rm -rf plugins
cp -rv ardour/libs/plugins .
cp -rv ardour/libs/fluidsynth ardour/libs/plugins/a-fluidsynth
rm -rf plugins/reasonablesynth.lv2
git checkout plugins/*/Makefile
