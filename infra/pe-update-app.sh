#!/bin/bash

declare -r logfile="${0}.log"
puppet job run --query \
    'resources[certname] { type = "Class" and title = "Profile::Myapp" }' \
  2>&1 | tee "${logfile}"

declare -r tok_miss=$(grep -c 'No credentials supplied' "${logfile}")
declare -r tok_exp=$(grep -c 'The provided token has expired' "${logfile}")
declare -r tok_rev=$(grep -c 'The provided token is revoked.' "${logfile}")

if [[ $tok_miss -gt 0 || $tok_exp -gt 0 || $tok_rev -gt 0  ]]; then
  echo 'Login required'
  err=1
  while [[ $err -ne 0 ]]; do
    read -p "(puppet admin) password: " -s password
    echo $password | puppet access login --username=admin --lifetime=1h
    err=$?
  done
  $0 # run again
fi
