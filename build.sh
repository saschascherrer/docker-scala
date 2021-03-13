#!/bin/bash
# Build a scala base image

# Get the latest SCALA and SBT (Scala Build Tool) Version so we can keep up to date
# Thanks for the hint, https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c#gistcomment-2552690
SCALA_LATEST_RELEASE_TAG=$(curl --silent "https://api.github.com/repos/scala/scala/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
SCALA_VERSION=${SCALA_LATEST_RELEASE_TAG:1}
SBT_LATEST_RELEASE_TAG=$(curl --silent "https://api.github.com/repos/sbt/sbt/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
SBT_VERSION=${SBT_LATEST_RELEASE_TAG:1}

echo "SCALA: $SCALA_VERSION (from Release Tag $SCALA_LATEST_RELEASE_TAG)"
echo "SBT:   $SBT_VERSION (from Release Tag $SBT_LATEST_RELEASE_TAG)"

if [[ ! -s scala-${SCALA_VERSION}.tgz ]]; then
        curl -q https://downloads.lightbend.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz > scala-${SCALA_VERSION}.tgz	
fi
if [[ ! -s sbt-${SBT_VERSION}.tgz ]]; then
        curl -q https://github.com/sbt/sbt/releases/download/${SBT_LATEST_RELEASE_TAG}/sbt-${SBT_VERSION}.tgz > sbt-${SBT_VERSION}.tgz	
fi

sed "s/@SCALA_VERSION/${SCALA_VERSION}/g" Dockerfile.template | sed "s/@SBT_VERSION/${SBT_VERSION}/g" > Dockerfile

sudo podman build \
	--tag scala:v${SCALA_VERSION} \
	--tag scala:sbt-v${SBT_VERSION} \
	.
