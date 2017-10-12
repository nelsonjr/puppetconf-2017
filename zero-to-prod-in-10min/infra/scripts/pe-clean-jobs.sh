su - pe-postgres -s /bin/bash \
  -c "/opt/puppetlabs/server/bin/psql \
  -f $(dirname $(realpath "$0"))/pe-clean-jobs.sql"
