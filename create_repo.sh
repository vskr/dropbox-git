#!/bin/bash
# This script is used to create a bare git repo of your project
# in your dropbox folder.

# Author: Sai

usage()
{
cat << EOF
usage: $0 options

This script creates a remote bare git repo of your project
in a dropbox directory

OPTIONS:
   -h      Show this message
   -s      Root of your project, that you wish to backup
   -r      Dropbox folder, where you want to create a backup
EOF
}

WORKING_PROJECT_ROOT=
DROPBOX_PROJECT_ROOT=
while getopts “hs:r:” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         s)
             WORKING_PROJECT_ROOT=${OPTARG%/*}
             ;;
         r)
             DROPBOX_PROJECT_ROOT=${OPTARG%/*}
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

if [[ -z $WORKING_PROJECT_ROOT ]] || [[ -z $DROPBOX_PROJECT_ROOT ]] 
then usage
     exit 1
fi

###Get absolute paths from possibly relative paths
cd $WORKING_PROJECT_ROOT
WORKING_PROJECT_ROOT=`pwd -P`
cd $DROPBOX_PROJECT_ROOT 
DROPBOX_PROJECT_ROOT=`pwd -P`

echo "Working project root is $WORKING_PROJECT_ROOT"
echo "Dropbox project root is $DROPBOX_PROJECT_ROOT"

###Init a repo in your working project root
cd "$WORKING_PROJECT_ROOT"
git init
PROJECT_NAME="${PWD##*/}"
REPO_NAME="$PROJECT_NAME.git"

###Init a remote bare repo in dropbox folder
cd "$DROPBOX_PROJECT_ROOT"
git init --bare "$REPO_NAME"

##Go back to your project 
##and set dropbox repo as your remote
cd "$WORKING_PROJECT_ROOT"
git remote add origin "$DROPBOX_PROJECT_ROOT/$REPO_NAME"

#Add all the files, and do a first commit
git add .
git commit -m"first commit"


#Push, for the first time
git push origin master
