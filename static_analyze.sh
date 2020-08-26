#!/bin/bash

# Assuming CodeChecker is installed and sourced

branch="$1"
commit="$2"
if [ -z "$1" ]; then
    branch="develop"
    commit="0000000"
fi

source /opt/openfoam7/etc/bashrc

set -x 

# check the code
CodeChecker check \
    -b "./Allwclean; ./Allwmake" \
    -i scripts/analyzer_skipfile \
    --checker-config \
    clang-tidy:cppcoreguidelines-special-member-functions.AllowMissingMoveFunctions=1\
    -o /tmp/static_results

# store check results
CodeChecker store /tmp/static_results \
    -n $branch --tag $commit \
    --url http://openrsr-code-check.herokuapp.com:80/OpenRSR

# Generate html reports
#CodeChecker parse -e html /tmp/results -o ./reports_html

rm -rf /tmp/static_results

#firefox http://localhost:8001
