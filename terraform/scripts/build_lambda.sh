#!/usr/bin/env bash
set -e
# This script is intended to be executed in the terraform/ directory (path.module)
LAMBDA_SRC_DIR="./lambda"
BUILD_DIR="./build"


rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"


cd "$LAMBDA_SRC_DIR"
zip -r -X "../build/lambda.zip" .


echo "Created $PWD/../build/lambda.zip"