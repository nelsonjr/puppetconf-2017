#!/bin/bash

declare -r instances=$(
  gcloud compute instances list --project graphite-demo-puppetconf-17-1 \
    | grep zero-to-prod | awk '{print $1}'
)
  
for i in $instances; do 
  echo "Applying catalog on $i"
  gcloud compute ssh --project graphite-demo-puppetconf-17-1 \
    --zone us-west1-a $i --command 'sudo puppet agent -t' &
done

echo 'Waiting for completion'
wait

echo 'All done'
