#!/bin/bash

# Define your variables
APP_DIR="/root/projects/java-app"
SAPP_DIR="java-app" # or the name of the directory you want
TOMCAT_WEBAPPS_DIR="/var/lib/tomcat/webapps"

# Create a directory for your app
mkdir -p "$APP_DIR"

# Clone your Java application repository
git clone https://github.com/Legamanchik/softserve_webapp.git "$APP_DIR/$SAPP_DIR"

# Navigate to your app directory
cd "$APP_DIR/$SAPP_DIR"

# Build the project with Gradle
./gradlew build test

# Stop the Tomcat service (if it's called toscato, adjust as needed)
systemctl stop tomcat

# Remove existing ROOT application
rm -rf "$TOMCAT_WEBAPPS_DIR/ROOT"

# Copy your application WAR file to Tomcat's webapps directory
cp build/libs/class-schedule.war "$TOMCAT_WEBAPPS_DIR/001.war"

# Start the Tomcat service
systemctl start tomcat9
