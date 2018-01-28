#!/bin/bash

find ./ -type f -name "$1" -print0 | xargs -0 eol_if