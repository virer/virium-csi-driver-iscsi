#!/bin/bash

# Increment version
TAG=$( cat VERSION | awk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{if(length($NF+1)>length($NF))$(NF-1)++; $NF=sprintf("%0*d", length($NF), ($NF+1)%(10^length($NF))); print}' )
echo "SWitch to version ${TAG}"
echo ${TAG} > VERSION
git tag ${TAG}
sed -i "s/var version =.*/var version = \"${TAG}\"/g" cmd/virium-controller/driver.go
sed -i "s/tag: .*/tag: ${TAG}/g" README.md
# EOF