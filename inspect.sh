#!/bin/bash

PROJECT_ROOT="$(dirname $0)"

rm -rf "${PROJECT_ROOT}/build"
"${PROJECT_ROOT}"/../checker/scan-build -checker-cfref -warn-dead-stores -warn-objc-methodsigs -warn-objc-missing-dealloc -warn-objc-unused-ivars -o $PWD/build/checker --view xcodebuild


