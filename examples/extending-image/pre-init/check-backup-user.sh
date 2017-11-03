# Check that user credentials for backup is set

[[ -v POSTGRESQL_BACKUP_USER && -v POSTGRESQL_BACKUP_PASSWORD ]] || usage "You have to set all variables for user for doing backup: POSTGRESQL_BACKUP_USER, POSTGRESQL_BACKUP_PASSWORD"
