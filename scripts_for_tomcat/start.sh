#!/bin/bash
sudo systemctl daemon-reload
sudo systemctl start postgresql
sudo systemctl start redis-server
sudo systemctl start tomcat9  # Replace with the correct service name if needed
sudo systemctl start mongod  # MongoDB might be started as 'mongod' service
