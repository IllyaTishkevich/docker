#!/usr/bin/env bash
PS3='Please, select sql dump: '

select FILE in /var/sql/src/*;
do
   if [ ${FILE: -3} == ".gz" ]; then
     echo "updating the database"
     zcat "$FILE" | mysql -u root -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE"
     echo "You picked $FILE ($REPLY), it is now only accessible to you."
     break;
   fi
   if [ ${FILE: -4} == ".sql" ]; then
     echo "updating the database"
     mysql -u root -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" < $FILE
     echo "You picked $FILE ($REPLY), it is now only accessible to you."
     break;
   fi
done