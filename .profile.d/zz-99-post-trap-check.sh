#!/usr/bin/env bash
echo "$(date -Is) zz-99-post-trap-check.sh sourced; invocations so far:" >> /tmp/console_profile_d.log
if [[ -f /tmp/php_invocations.log ]]; then
  cat /tmp/php_invocations.log >> /tmp/console_profile_d.log
else
  echo "(none — php was not invoked during profile.d init)" >> /tmp/console_profile_d.log
fi
