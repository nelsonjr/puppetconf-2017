#!/bin/bash

for manifest in *-down-*.pp; do
  echo "Applying: ${manifest} ============"
  puppet apply $manifest
done
