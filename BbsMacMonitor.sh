#!/usr/bin/env bash
# BbsMacMonitor
# @author glassCodeBender
# @date September 18, 2018
#
# Description: Program to monitor MacOS behavior. Results are stored in /Documents/BbsMacMonitor/Results
#

# Location of all logs
logLocation="$HOME/Documents/BbsMacMonitor"

# Location of previous disk usage results
previousResultsLoc="$HOME/Documents/BbsMacMonitor/RawData/dupreviousresults.log"

# Declare variables for filenames where we will store text and program locations that we'll use. 
epochDate=$(date +%s)
todaysDate=$(date)
pythonLoc="$HOME/usr/bin/python2.6"
scalaLoc="$HOME/usr/bin/..."
tcpdumpLoc="/home/user/bin/tcpdump"
diffLoc=${logLocation}/RawData/duDifference${epochDate}.txt # Location of difference between previous du and current

# Test if paths to python and scala are on computer
# THIS IS NOT WORKING
if [ -x ${pythonLoc} ];
	then echo Could not find python at location: ${pythonLoc};
fi

if [ -x ${scalaLoc} ];
	then echo Could not find Scala at location: ${scalaLoc};
fi

# Create necessary directories for program
mkdir -p ${logLocation}/RawData
mkdir -p ${logLocation}/ComparisonResults

##### du

# Compare the difference between what's on disk on one date and another
# Need current results
du -a -k > ${logLocation}/RawData/CurrentResults.log

if [ -x ${previousResultsLoc} ];
	then du -a -k > ${previousResultsLoc}
fi

##### diff 
diff ${logLocation}/RawData/CurrentResults.log ${previousResultsLoc} > ${diffLoc}

# Overwrite previous results with current results
du -a -k > ${previousResultsLoc}

# Stores shell command history 
bashHistory=$(history)

echo ${bashHistory}

# We want to look at more than the two commands below.
# Looking for listening and established connections
listeningConns=$(netstat -nab | grep "LISTEN")
establishedConns=$(netstat -nab | grep "ESTABLISHED")

echo ${listeningConns}
echo ${establishedConns}

# NEED TO REMOVE THE LOG FILES WE JUST WROTE TO WITH GREP

# make the flag Read-Only
chmod 444 ${diffLoc}

# make the file immutable
chflags uchg ${diffLoc}
# chown root ${diffLoc}

exit 0
