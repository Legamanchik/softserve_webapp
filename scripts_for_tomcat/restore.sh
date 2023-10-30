sudo -u postgres psql --set ON_ERROR_STOP=off -d schedule -f "/tmp/init.dump"
sudo -u postgres psql --set ON_ERROR_STOP=off -d schedule -f "/tmp/init.dump"
