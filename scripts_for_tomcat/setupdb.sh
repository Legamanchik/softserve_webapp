#!/bin/bash

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
                      -c "ALTER DATABASE schedule_test OWNER TO $POSTGRES_USERNAME;" > /dev/null 2>&1

# Create .pgpass file
sudo touch ".pgpass"
echo "127.0.0.1:5432:*:$POSTGRES_USERNAME:$POSTGRES_PASSWORD" | sudo tee ".pgpass" > /dev/null
sudo chmod 0600 ".pgpass"
sudo chown postgres:postgres ".pgpass"
echo PGPASSFILE=".pgpass" | sudo tee -a /etc/environment > /dev/null

# Restore dump
sudo -u postgres psql --set ON_ERROR_STOP=off -U "$POSTGRES_USERNAME" -h 127.0.0.1 -d "$POSTGRES_DB" -f "$DUMP_FILE" > /dev/null 2>&1
sudo systemctl restart postgresql
