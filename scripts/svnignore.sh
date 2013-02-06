#!/bin/bash
# ------------svnignore.sh------------------------------------------------
# A small script to automatically set svn to ignore unversioned files in
# each directory passed through the arguments.
# 
# Author: Peter Slawski
# Date:   05/02/2013
# 
# ------------installation------------------------------------------------
# chmod 755 svnignore.sh
#
# ------------example-----------------------------------------------------
# To ignore all unversioned files in the folders below, execute:
#   linux-goldfish-2.6.29
#   linux-goldfish-2.6.29/kernel
#   linux-goldfish-2.6.29/arch/arm
#
# cd ~/ece353/android/kernel/linux-goldfish-2.6.29
# ./svnignore.sh . kernel arch/arm
# 

for var in "$@"
do
  # Note: ignore_file may be set to be ignored if argument .. is passed
  svn propget svn:ignore $var > ../ignore_file
  # Added only the filenames of the unversioned files
  svn status --non-recursive $var | grep ? | sed "s/\? *//" | xargs -L1 basename >> ../ignore_file
  svn propset svn:ignore --file ../ignore_file $var
  rm ../ignore_file
done
