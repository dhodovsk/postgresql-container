# create backup user

psql -U postgres -d $POSTGRESQL_DATABASE -c "CREATE USER $POSTGRESQL_BACKUP_USER SUPERUSER  password '$POSTGRESQL_BACKUP_PASSWORD';"
psql -U postgres -d $POSTGRESQL_DATABASE -c "ALTER USER $POSTGRESQL_BACKUP_USER set default_transaction_read_only = on;"
