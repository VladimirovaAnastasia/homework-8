#!/bin/bash

echo "Run tests"

current_tag=$(git tag | tail -1 | head -n1)

result=$(npm run test 2>&1  | tr -s "\n" " ")

comment="Test Results: $result"

echo $comment

./.github/scripts/createTask.sh "$comment"
