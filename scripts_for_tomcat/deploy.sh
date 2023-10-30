#!/bin/bash

# Define your variables
APP_DIR="/root/projects/java-app"
SAPP_DIR="ClassSchedule" # or the name of the directory you want
TOMCAT_WEBAPPS_DIR="/var/lib/tomcat9/webapps"

# Create a directory for your app
mkdir -p "$APP_DIR"

# Clone your Java application repository
git clone https://github.com/BlueTeam2/ClassSchedule "$APP_DIR/$SAPP_DIR"

#setenv for tomcat
cp .env /usr/share/tomcat9/bin/
cd /usr/share/tomcat9/bin/
mv .env setenv.sh
chmod +x setenv.sh

# Navigate to your app directory
cd "$APP_DIR/$SAPP_DIR"

# Build the project with Gradle
chmod +x ./gradlew
./gradlew assemble

# Stop the Tomcat service (if it's called toscato, adjust as needed)
systemctl stop tomcat9.service

# Remove existing ROOT application
rm -rf "$TOMCAT_WEBAPPS_DIR/ROOT"

# Copy your application WAR file to Tomcat's webapps directory
cp build/libs/class_schedule.war "$TOMCAT_WEBAPPS_DIR/ROOT.war"


# Start the Tomcat service
systemctl start tomcat9.service  

