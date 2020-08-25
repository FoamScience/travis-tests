#!/bin/bash

# Assuming CodeChecker is installed and sourced

# fire up service
product="$1"
if [ -z "$1" ]; then
    product="OpenRSR"
fi

source /opt/openfoam7/etc/bashrc

set -x 

# check the code
CodeChecker check \
    -b "./Allwclean; wmake libso src/rsr" \
    -i scripts/analyzer_skipfile \
    --checker-config \
    clang-tidy:cppcoreguidelines-special-member-functions.AllowMissingMoveFunctions=1\
    -o /tmp/static_results

# store check results
CodeChecker cmd products \
    add --url http://openrsr-code-check.herokuapp.com:80 OpenRSR
CodeChecker store /tmp/static_results \
    -n $product \
    --url http://openrsr-code-check.herokuapp.com:80/OpenRSR

# Generate html reports
#CodeChecker parse -e html /tmp/results -o ./reports_html

rm -rf /tmp/static_results

#firefox http://localhost:8001
