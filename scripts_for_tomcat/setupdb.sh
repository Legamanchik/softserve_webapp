#!/bin/bash

if [ -f .env ]; then
  source .env
else
  echo "Error: .env file not found."
  exit 1
fi

# Create a PostgreSQL user
sudo -u postgres psql -c "CREATE USER $POSTGRE_USER WITH PASSWORD '$POSTGRE_PASSWORD'"

# Create a PostgreSQL database
sudo -u postgres psql -c "CREATE DATABASE $DB_NAME WITH OWNER $POSTGRE_USER"

# Set up the .pgpass file for password authentication
echo "$DB_HOST:$DB_PORT:$DB_NAME:$POSTGRE_USER:$POSTGRE_PASSWORD" >> /var/lib/postgresql/.pgpass
chmod 0600 /var/lib/postgresql/.pgpass

# Copy the dump file to the PostgreSQL data directory
cp "$DUMP_FILE" /var/lib/postgresql/

# Restore the dump file to the PostgreSQL database
sudo -u postgres pg_restore -U $POSTGRE_USER -h $DB_HOST -d $DB_NAME -f "/var/lib/postgresql/$DUMP_FILE"
