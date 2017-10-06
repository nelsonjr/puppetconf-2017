su - pe-postgres -s /bin/bash \
  -c "/opt/puppetlabs/server/bin/psql -f $PWD/pe-clean-jobs.sql"
