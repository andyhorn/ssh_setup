#!/bin/bash

# Andrew Horn, copyright 2021
# Configure a new Raspberry Pi OS to enable SSH over USB

CONFIG_FILE="config.txt"
CMDLINE_FILE="cmdline.txt"
OVERLAY="dtoverlay=dwc2"
MODULES="modules-load=dwc2,g_ether"

# Add the overlay to the end of the config file
echo "Step 1) Configure config.txt file with dtoverlay parameter..."
EXISTS=$(cat $CONFIG_FILE | grep "$OVERLAY")
if [ -z "$EXISTS" ];
  then
    cp $CONFIG_FILE "$CONFIG_FILE.old"
    echo "Backed up current file to $CONFIG_FILE.old"
    echo $OVERLAY >> $CONFIG_FILE
    echo "Configuration complete!"
  else
    echo "config.txt file already configured - skipping this step."
  fi

# Add the modules info after the "rootwait" command in the cmdline file
echo "Step 2) Configure cmdline.txt file with modules-load parameter..."
EXISTS=$(cat $CMDLINE_FILE | grep "$MODULES")
if [ -z "$EXISTS" ];
  then
    cp "./$CMDLINE_FILE" "$CMDLINE_FILE.old"
    echo "Backed up current file to $CMDLINE_FILE.old"
    sed -i -n "s/rootwait /rootwait $MODULES /" $CMDLINE_FILE
    echo "Configuration complete!"
  else
    echo "cmdline.txt file already configured - skipping this step."
  fi

# Create the ssh file to enable SSH
echo "Step 3) Create an empty 'ssh' file to enable SSH..."
EXISTS=$(ls | grep ssh$)
if [ -z "$EXISTS" ];
  then
    touch ssh
    echo "File created!"
  else
    echo "The ssh file already exists - skipping this step."
  fi
