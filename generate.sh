#!/bin/bash

CODEGEN_VERSION="2.2.2"

mkdir -p bin
if [ ! -f "bin/swagger-codegen-cli.jar" ]; then
    curl -o "bin/swagger-codegen-cli.jar" \
        "https://oss.sonatype.org/content/repositories/releases/io/swagger/swagger-codegen-cli/$CODEGEN_VERSION/swagger-codegen-cli-$CODEGEN_VERSION.jar"
fi

ACTUAL_CODEGEN_VERSION=$(java -jar "bin/swagger-codegen-cli.jar" version)
if [ "$ACTUAL_CODEGEN_VERSION" != "$CODEGEN_VERSION" ]; then
    echo "Expected swagger-codegen-cli version $CODEGEN_VERSION, actual version $ACTUAL_CODEGEN_VERSION"
    exit 1
fi

CODEGEN="java -jar bin/swagger-codegen-cli.jar"
CONFIG=".codegen.json"
TAG=$(git describe --tags)
VERSION="${TAG/v/}"

echo "{\"packageName\":\"payoneer_mobile_api\",\"packageVersion\":\"$VERSION\"}" > $CONFIG
$CODEGEN generate -i swagger.yaml -l python -o python -c $CONFIG \
    --git-user-id "brainbeanapps" --git-repo-id "payoneer-mobile-api-python"
