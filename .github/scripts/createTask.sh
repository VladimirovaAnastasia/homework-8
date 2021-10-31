#!/bin/bash

comment=$1

current_tag=$(git tag | tail -1 | head -n1)
tag="vladimirova$current_tag"

taskURL=$(curl  \
-d '{"filter": { "unique": "'"${tag}"'"}}' \
-H "Content-Type: application/json"  \
-H "Authorization: OAuth ${OAuth}" \
-H "X-Org-ID: ${OrgId}" \
-X POST https://api.tracker.yandex.net/v2/issues/_search/ | awk -F '"self":"' '{ print $2 }' | awk -F '","' '{ print $1 }')

echo $taskURL

code=$(curl -w "%{http_code}\\n" \
-d '{"text": "'"${comment}"'"}' \
-H "Content-Type: application/json"  \
-H "Authorization: OAuth ${OAuth}" \
-H "X-Org-ID: ${OrgId}" \
-X POST "${taskURL}/comments" \
-s -o /dev/null)

echo $code
if [ "$code" = 201 ];
  then echo "Task updated successfully!"
  else echo "Something wrong"
fi

exit 0
