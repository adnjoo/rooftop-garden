#!/bin/bash

echo "Counting SLOC (.gd + .tscn)..."

find . \
  \( -name "*.gd" -o -name "*.tscn" \) \
  -type f -print0 \
| xargs -0 wc -l
