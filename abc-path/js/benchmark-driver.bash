#! /usr/bin/env bash
#
# benchmark-driver.bash
# Copyright (C) 2024 Shlomi Fish < https://www.shlomifish.org/ >
#
# Distributed under the terms of the ISC license.
#
# WARNING: The conent and behaviour of this file is subject to change

set -e -x

gmake

run_bench()
{
    args="$1"
    shift
    timestamps_log_fn="$1"
    shift
    NODE_PATH="`pwd`"/lib/for-node/js node lib/for-node/js/benchmark.js $args | timestamper-with-elapsed --from-start --output "$timestamps_log_fn"
}

run_bench "--mt" "mt-rand.log.txt"
run_bench "--ms" "ms-rand.log.txt"
