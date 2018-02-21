#!/bin/bash
#echo args=$*

GEN_JAVA=
GEN_SWIFT=
BUILD=build

usage() { echo Usage: $0 "[-j] [-s] [-b build_dir]" 1>&2; exit 1; }

while getopts ":jsb:" opt; do
    case $opt in
        j)
            GEN_JAVA=1
            ;;
        s)
            GEN_SWIFT=1
            ;;
        b)
            BUILD=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done

options="-b $PWD/build"
if [ -n "$GEN_JAVA" ]; then
    options="-j ${options}"
fi
if [ -n "$GEN_SWIFT" ]; then
    options="-s ${options}"
fi

#echo "options=$options"
tools/build-helpdesk.sh $options
