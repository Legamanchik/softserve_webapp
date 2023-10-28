#!/bin/bash

# Check if .env file exists
if [ -f .env ]; then
  source .env
else
  echo "Error: .env file not found."
  exit 1
fi

# Configure PostgreSQL
sudo -u postgres psql -c "CREATE DATABASE schedule;" \
                      -c "CREATE DATABASE schedule_test;" \
                      -c "CREATE USER $POSTGRES_USERNAME WITH PASSWORD '$POSTGRES_PASSWORD';" \
                      -c "GRANT ALL PRIVILEGES ON DATABASE schedule TO $POSTGRES_USERNAME;" \
                      -c "ALTER DATABASE schedule OWNER TO $POSTGRES_USERNAME;" \
                      -c "GRANT ALL PRIVILEGES ON DATABASE schedule_test TO $POSTGRES_USERNAME;" \
                      -c "ALTER DATABASE schedule_test OWNER TO $POSTGRES_USERNAME"

# Create .pgpass file
PGPASSFILE="/var/lib/postgresql/.pgpass"
echo "127.0.0.1:5432:*:$POSTGRES_USERNAME:$POSTGRES_PASSWORD" | sudo tee "$PGPASSFILE" > /dev/null
sudo chmod 0600 "$PGPASSFILE"
sudo chown postgres:postgres "$PGPASSFILE"

# Add PGPASSFILE environment variable
echo "export PGPASSFILE=$PGPASSFILE" | sudo tee -a /etc/environment > /dev/null

# Restore dump
DUMP_FILE="2023-09-07.dump"
sudo -u postgres psql --set ON_ERROR_STOP=off -d schedule -f "/tmp/init.dump"
sudo -u postgres psql --set ON_ERROR_STOP=off -d schedule_test -f "/tmp/init.dump"

# Restart PostgreSQL
sudo systemctl restart postgresql
