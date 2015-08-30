#!/bin/bash

#Changes the owner of the tables, sequences and views for a postgres database;

echo -e "\nPGSQL Change Owner Script\n"
if test $# -lt 2; then
  echo "usage: $0 <database-name> <new-owner>"
  exit 0
fi

DATABASE=$1
NEW_OWNER=$2
PSQL="sudo -u postgres `which psql` -qAt";
TABLES=`$PSQL -c "select tablename from pg_tables where schemaname = 'public';" $DATABASE; $PSQL -c "select sequence_name from information_schema.sequences where sequence_schema = 'public';" $DATABASE; $PSQL -c "select table_name from information_schema.views where table_schema = 'public';" $DATABASE`;

echo echo "Changing owner to $NEW_OWNER on database $DATABSE"
for TBL in $TABLES; do
    echo "Changing owner to $NEW_OWNER on table $TBL"
    $PSQL -c "alter table $TBL owner to $NEW_OWNER" $DATABASE;
done;
