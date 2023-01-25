#!/bin/bash
CURRENT_BRANCH=$(git branch --show-current)
UNTRACKED_FILES=$(git status -u -s | grep -v .terraform.lock.hcl | wc -l)
ADDED_FILES=$(git status -s| grep '^A'|wc -l)
MODIFIED_FILES=$(git status -s| grep '^M'|wc -l)
DEPLOYMENT_NAME=$(basename $PWD)
HEAD_COMMIT_ID=$(git show HEAD -q | head -n 1 | awk '{print $2};')
HEAD_COMMIT_AUTHOR=$(git show HEAD -q | head -n 3 | grep Author | awk '{$1=""; print $0}' | tr -Cd '[:alnum:] _.:/=+\-@')
HEAD_COMMIT_DATE=$(git show HEAD -q | head -n 3 | grep Date | awk '{$1=""; print $0}')
HEAD_COMMIT_DATE_AUTHOR="$HEAD_COMMIT_DATE $HEAD_COMMIT_AUTHOR"
HEAD_COMMIT_ONELINE=$(git show HEAD -q --oneline | tr -Cd '[:alnum:] _.:/=+\-@')
TIMESTAMP=$(date +%s)

if [[ $1 == "minimal" ]]; then
echo """{
\"current_branch\":\"${CURRENT_BRANCH}\",
\"current_user\":\"${USER}\",
\"deployment_name\":\"${DEPLOYMENT_NAME}\",
\"head_commit_id\":\"${HEAD_COMMIT_ID}\",
\"timestamp\":\"${TIMESTAMP}\"
}"""
else
echo """{
\"current_branch\":\"${CURRENT_BRANCH}\",
\"current_user\":\"${USER}\",
\"files\":\"untracked $(echo $UNTRACKED_FILES) added $(echo $ADDED_FILES) modified $(echo $MODIFIED_FILES)\",
\"deployment_name\":\"${DEPLOYMENT_NAME}\",
\"head_commit_id\":\"${HEAD_COMMIT_ID}\",
\"head_commit_date_author\":\"${HEAD_COMMIT_DATE_AUTHOR}\",
\"head_commit_oneline\":\"${HEAD_COMMIT_ONELINE:0:255}\",
\"timestamp\":\"${TIMESTAMP}\"
}"""
fi

