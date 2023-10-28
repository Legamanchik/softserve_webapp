#!/bin/bash

if [ -f .env ]; then
  source .env
else
  echo "Error: .env file not found."
  exit 1
fi

# Create a PostgreSQL user
sudo -Hiu postgres psql -c "CREATE USER $POSTGRE_USER WITH PASSWORD '$POSTGRE_PASSWORD'"

# Create a PostgreSQL database
sudo -Hiu postgres createdb -O $POSTGRE_USER $DB_NAME

# Set up the .pgpass file for password authentication
echo "$DB_HOST:$DB_PORT:$DB_NAME:$POSTGRE_USER:$POSTGRE_PASSWORD" >> ~/.pgpass
chmod 0600 ~/.pgpass

# Restore the dump file using psql
sudo -Hiu postgres psql -U $POSTGRE_USER -d $DB_NAME < "$DUMP_FILE"
