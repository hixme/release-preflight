IFS=$'\n'
TMP_FILE=/tmp/release-$(date +"%T").log

git log origin/master..origin/develop --oneline --no-merges --no-decorate > $TMP_FILE

if [[ -z "$USERNAME" ]] || [[ -z "$PASS" ]]; then
  echo "Enter JIRA credentials"
  echo -n "Username: "
  read USERNAME

  echo -n "Password: "
  read -s PASS
  printf "\n"
fi

downloadIssue() {
  BRANCH_NAME=$1
  ISSUE_KEY=$(echo $BRANCH_NAME | cut -d '/' -f 2)

  # Issue call requires auth token to be passed as environment variable on JIRA_AUTH
  curl -s --request GET \
    -u "$USERNAME:$PASS" \
    --url "https://$JIRA_DOMAIN.atlassian.net/rest/api/3/issue/$ISSUE_KEY?fields=summary" \
    --header "Accept: application/json" | \
   perl -nle'print $& while m{"'"summary"'"\s*:\s*"\K([^"]*)}g'
}

cleanUp() {
  rm $TMP_FILE
  unset IFS
}

OTHER=()
CONVENTIONAL=()
while read -r commit ; do
  if echo $commit | grep -q "release/*"; then
    continue
  elif echo $commit | grep -qE "^[^:]*$"; then 
    OTHER=("${OTHER[@]}" "$(echo $commit | cut -c 10-)")
  elif echo $commit | grep -qE "[A-Za-z]{3,11}\/[A-Za-z]{2,4}-[0-9]{1,5}"; then
    CONVENTIONAL=("${CONVENTIONAL[@]}" "$(echo $commit | cut -c 10- | cut -d ':' -f 1)")
  else
    OTHER=("${OTHER[@]}" "$(echo $commit | cut -c 10- | cut -d ':' -f 1)")
  fi
done < $TMP_FILE

SORTED_CONVENTIONAL=($(sort -u <<<"${CONVENTIONAL[*]}"))
SORTED_OTHER=($(sort -u <<<"${OTHER[*]}"))

echo "==================== TICKETS ===================="
for i in "${SORTED_CONVENTIONAL[@]}"
do
  ISSUE_TITLE=$(downloadIssue $i)
  if [[ -n $ISSUE_TITLE ]]; then
    echo "$i: $ISSUE_TITLE"
  else
    echo $i
  fi
done

echo "==================== OTHER ======================"
echo "${SORTED_OTHER[*]}"

cleanUp
