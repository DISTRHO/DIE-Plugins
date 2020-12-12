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
cp -rv ardour/libs/fluidsynth plugins/a-fluidsynth.lv2/fluidsynth
rm -rf plugins/reasonablesynth.lv2
git checkout plugins/*/Makefile

# custom URI
sed -i -e "s/:ardour:/:distrho:/" plugins/a-*.lv2/*.c
sed -i -e "s/:ardour:/:distrho:/" plugins/a-*.lv2/*.ttl.in
sed -i -e "s/ACE /DIE /" plugins/a-*.lv2/*.ttl.in
sed -i -e "s/doap:maintainer/doap:developer/" plugins/a-*.lv2/*.ttl.in
