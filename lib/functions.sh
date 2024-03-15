#!/bin/bash
#
# Script Name: functions.sh
#
# Description: This script isn't meant to be called directly. This is just a collection of 
# helper functions that can be sourced by other scripts.
#
# Author: Abinadi Swapp
# Date: March 15, 2024
# Version: 1.0
#
# Usage: source /lib/funtions.sh
#




# sets a variable in 
# any given file 
function setVar() {
    local file="$1"
    local variable="$2"
    local value="$3"
    
    # Use awk to update the variable value in a temporary file
    awk -v var="$variable" -v val="$value" 'BEGIN { FS = "=" } $1 == var {print var "=" "\"" val "\""; next} {print $0}' "$file" > "$file.tmp"

  
    # Replace the original file with the updated content
    mv "$file.tmp" "$file"

    # so that permission don't keep changing
    chmod 777 $file
}

# sets a variable array
# in another file
function setVarArray() {
    local file="$1"
    local variable="$2"
    local values=("${@:3}")

    # Serialize the array into a string (comma-separated values)
    local serialized_values="($(printf ' "%s"' "${values[@]}"))"  

    # Use awk to update the variable value in a temporary file
    awk -v var="$variable" -v val="$serialized_values" 'BEGIN { FS = "=" } $1 == var {print var "=" val; next} {print $0}' "$file" > "$file.tmp"

    # Replace the original file with the updated content
    mv "$file.tmp" "$file"

    # Set permissions (adjust as needed) u=rwx for when this is in production
    chmod 777 "$file"
}

# backups a file 
function backup() {
    local file="$1"
    cp $file "$file.backup"
}



export -f setVar()

export -f setVarArray()

export -f backup()