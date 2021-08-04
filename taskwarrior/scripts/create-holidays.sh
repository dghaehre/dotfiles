#!/bin/bash

# Run this script with current year as argument
# to output holiday data to the .taskrc file
#
# Example: ./create-holidays.sh 2021

curl http://holidata.net/nb-NO/$1.csv | awk -f  holidata.awk >> ~/.taskrc
