\connect pe-puppetdb
DELETE FROM certnames WHERE certname LIKE 'zero-to-prod-%';
\connect pe-orchestrator
DELETE FROM jobs where id > 1;
\quit
