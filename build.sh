#!/bin/bash

set -e

REGISTRY="registry.oc.univie.ac.at"
NAMESPACE="schambm7"
NODEPREFIX="opencast"
PARENT_DIR=$(basename "${PWD%/*}")
CURRENT_DIR="${PWD##*/}"

export TAG="${1:-latest}"
export REPO="${2:-https://github.com/opencast/opencast.git}"
export BRANCH="${1:-develop}"


if [ -z "$REGISTRY" ]; then
	if [ -z "$NAMESPACE" ]; then
		IMAGEURL=$NODEPREFIX
	else
		IMAGEURL=$NAMESPACE/$NODEPREFIX
	fi
else
	if [ -z "$NAMESPACE" ]; then
		IMAGEURL=$REGISTRY/$NODEPREFIX
	else
		IMAGEURL=$REGISTRY/$NAMESPACE/$NODEPREFIX
	fi
fi

echo
echo "**********************************"
echo "*     Opencast Docker Images     *"
echo "**********************************"
echo
echo "- Repository:  $REPO"
echo "- Branch:      $BRANCH"
echo
echo "**********************************"
echo
echo "* Build Opencast and Base images for nodes"
echo

cd ./.source
echo "- Build image: $IMAGEURL-source:$TAG"
docker build --build-arg branch=$BRANCH \
  					 --build-arg repo=$REPO -t $IMAGEURL-source:${TAG} .
docker push ${IMAGEURL}-source:${TAG}
cd ..

cd ./.base
echo "- Build image: $IMAGEURL-base:$TAG"
#docker build -t $IMAGEURL-base:${TAG} .
echo docker push ${IMAGEURL}-base:${TAG}
cd ..

echo
echo "**********************************"
echo
echo "* Build Opencast nodes and required services"
echo

for d in ./*/ ; do (
	cd "$d" &&
	echo "- Build image: $IMAGEURL-${PWD##*/}:$TAG"
	docker build --build-arg tag=$BRANCH \
							 -t $IMAGEURL-${PWD##*/}:$TAG .
	echo docker push ${IMAGEURL}-${PWD##*/}:${TAG}
); done

echo
echo "**********************************"
echo
