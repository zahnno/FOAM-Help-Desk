#!/bin/bash
echo -e "\nbuilding helpdesk"
#echo args=$*

GEN_JAVA=
GEN_SWIFT=
BUILD=build

usage() { echo Usage: $0 "[-j] [-s] -b build_dir" 1>&2; exit 1; }

while getopts ":jb:" opt; do
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

#NOTE: not using $BUILD 
cp src/main/css/*.css build/webapp/css 2>>/dev/null
cp src/main/images/* build/webapp/images 2>>/dev/null
#cp src/main/js/libs/*.js build/webapp/js 2>>/dev/null

node tools/build.js flags=web,debug,js bin=$BUILD/webapp/js/helpdesk-bin.js
node tools/build.js flags=data,_only_ bin=$BUILD/webapp/data/helpdesk-data-bin.js
node tools/build.js flags=main,_only_ bin=$BUILD/webapp/js/helpdesk-main-bin.js
node tools/build.js flags=css,_only_ bin=$BUILD/webapp/js/helpdesk-css-bin.js

if [ -n "$GEN_JAVA" ]; then
    echo -e "generating java to $BUILD/src/java"
    node tools/build.js flags=web,debug,java,node bin=$BUILD/helpdesk-java-bin.js
    (
        node tools/genjava.js tools/classes.js $BUILD/src/java ../src/main
    )
    # cleanup
    #rm -f $BUILD/*-java-bin.js
fi
