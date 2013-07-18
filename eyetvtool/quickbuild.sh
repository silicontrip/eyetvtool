#!/bin/sh
gcc -O2 -Wall -force_cpusubtype_ALL -mmacosx-version-min=10.5 -arch i386 -arch ppc -o eyetvtool -framework Foundation -framework ApplicationServices  *.m
