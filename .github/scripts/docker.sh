#!/bin/bash

echo "Run docker"

current_tag=$(git tag | tail -1 | head -n1)

docker build . -f Dockerfile -t ${current_tag}

if [ $? -ne 0 ]
then
    result="Creation docker image faild"
else
    result="Created docker image: ${current_tag}"
fi

./.github/scripts/createTask.sh "$result"
