#!/bin/bash

set -e

REGISTRY=""
NAMESPACE=""
NODEPREFIX="opencast-mt"
PARENT_DIR=$(basename "${PWD%/*}")
CURRENT_DIR="${PWD##*/}"


export REPO="${2:-https://github.com/opencast/opencast.git}"
export BRANCH="${1:-develop}"
echo $BRANCH > foo.txt
TAB=$(cut -d/ -f2 foo.txt)
if [ $BRANCH = "develop" ]; then
	TAG="develop"
else
	TAG=$TAB
fi

rm foo.txt

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
echo "- Pushing to:  $IMAGEURL-*:$TAG"
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
docker build -t $IMAGEURL-base:${TAG} .
docker push ${IMAGEURL}-base:${TAG}
cd ..

echo
echo "**********************************"
echo
echo "* Build Opencast nodes and required services"
echo

for d in ./*/ ; do (
	cd "$d" &&
	echo "- Build image: $IMAGEURL-${PWD##*/}:$TAG"
	docker build --build-arg tag=$TAG \
	             --build-arg registry=$REGISTRY \
							 --build-arg nodeprefix=$NODEPREFIX \
							 -t $IMAGEURL-${PWD##*/}:$TAG .
	docker push ${IMAGEURL}-${PWD##*/}:${TAG}
); done

echo
echo "**********************************"
echo
