#!/bin/bash

echo "Release creation"

current_tag=$(git tag | tail -1 | head -n1)
previous_tag=$(git tag | tail -2 | head -n1)

author=$(git show ${current_tag} | grep Author: | head -1)
date=$(git show ${current_tag} | grep Date: | head -1)
changeLog=`git log "${previous_tag}"..${current_tag} --pretty=format:"\n* %h %s - %cn %ce;" | tr -s "\n" " "`
tag="vladimirova$current_tag"

summary="Release ${current_tag} vladimirova"
description="${author}\n ${date}\n ChangeLog:\n ${changeLog}"

code=$(curl -w "%{http_code}\\n" \
-d '{"summary": "'"${summary}"'", "description": "'"${description}"'", "queue": "TMP", "unique": "'"${tag}"'"}' \
-H "Content-Type: application/json"  \
-H "Authorization: OAuth ${OAuth}" \
-H "X-Org-ID: ${OrgId}" \
-X POST https://api.tracker.yandex.net/v2/issues/ \
-s -o /dev/null)

if [ "$code" = 201 ];
  then echo "Task created successfully!"
  exit 0
fi

if [ "$code" = 409 ]
  then echo "Task already exists!"
  else echo "Some problems"
fi

exit 0
