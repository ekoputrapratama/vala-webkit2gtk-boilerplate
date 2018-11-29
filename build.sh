#!/usr/bin/env bash

rm -rf build && meson build && cd build && ninja && cd ..
