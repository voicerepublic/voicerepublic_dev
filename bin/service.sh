#!/bin/bash
# Thu Feb 17 14:56:42 CEST 2016
# Phil Hofmann
# Switzerland, Zürich, VoiceRepublic

__pwd="$(pwd -P)"
__mydir="${0%/*}"
__abs_mydir="$(cd "$__mydir" && pwd -P)"
__myname=${0##*/}
__abs_myname="$__abs_mydir/$__myname"

. ~/bin/rbenv_init

export RAILS_ENV=production

bundle=$HOME/.rbenv/shims/bundle
service="${bundle} exec bin/service ${@}"

# Rails is always located below ~/app/current
cd ~/app/current

echo ${service}
${service}
