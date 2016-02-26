#!/bin/bash

# Add b2 as base command if needed
if [ "${1:0:2}" != 'b2' ]; then
	if [ ${1} = "upload_file_replace" ]; then
		set -- python /usr/bin/b2_upload_file_replace "$@"
	else
		set -- b2 "$@"
	fi
fi

EXIT_CODE=1
AUTH_FAILED=1
RETRY=0

if [ -n "$B2_ACCOUNT_ID" ] && [ -n "$B2_APPLICATION_KEY" ]; then
  while [ $AUTH_FAILED -ne 0 ] && [ $RETRY -lt $AUTHORIZATION_FAIL_MAX_RETRIES ]; do
    # Exclude on first run only if /root/.b2_account_info exists
    if [ $RETRY -gt 0 ] || [ ! -f /root/.b2_account_info ]; then
      b2 authorize_account "$B2_ACCOUNT_ID" "$B2_APPLICATION_KEY"
    fi
    OUTPUT=`$@`
    if [[ $OUTPUT != *"bad_auth_token"* ]] && [[ $OUTPUT != *"expired_auth_token"* ]]; then
      AUTH_FAILED=0
    fi
    EXIT_CODE=$?
    RETRY=$((RETRY+1))
  done
  echo $OUTPUT
else
  $@
fi
