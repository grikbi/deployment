#!/bin/bash

#file="/tmp/data/coreapi.dump"
#file="/var/lib/pgsql/data/coreapi.dump"
file="/var/lib/pgsql/data/pgdump.sql"
dbname=coreapi

echo "Restoring DB using $file"
#pg_restore -U coreapi --dbname=$dbname --verbose --single-transaction < "$file" || exit 1

psql -U coreapi -d $dbname  < "$file" || exit 1

