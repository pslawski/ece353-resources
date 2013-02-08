#!/usr/bin/perl
# ------------svnignoreall.sh---------------------------------------------
# A script to automatically set svn to ignore all unversioned files in the
# current directory recursively.
# 
# Author:   Peter Slawski
# Date:     07/02/2013
#
# ------------Installation------------------------------------------------
# This script requires perl to run:
# Linux:  sudo apt-get install perl
# OSX:    Install Xcode from the app store. 
#
# Set permission to execute:
# chmod 755 svnignoreal.pl

use strict;
use warnings;

# Set svn:ignore property for a particular folder.
# $_[0] The path directory
# $_[1] The reference to the array of files/folder names to ignore
sub svnignore 
{
  # Check if the 
  if(@{$_[1]}){
    my $cur_ignore = `svn propget svn:ignore $_[0]`;
    my $last = substr $cur_ignore, -1, 1;
    if ($last ne "\n") {
      $cur_ignore = "$cur_ignore\n";
    }
    foreach my $name (@{$_[1]}) {
      $cur_ignore .= "$name\n";
    }
    open FILE, ">ignore_temp" or die $!;
    print FILE "$cur_ignore";
    close FILE;

    system "svn propset svn:ignore --file ignore_temp $_[0]";
    system "rm ignore_temp";
  } 
}

# Main:
# Retrive list of unversion files and folders in the current diectory.
my $output = `svn status . | grep ? | sed "s/\? *//"`;
my @paths = split /\n/, $output;
my %hash;

foreach my $path (@paths) {
  # $location: the path to the file or folder
  # $name: the file or folder name or the path
  my ($location, $name) = split (m{/([^/]+)$}, $path);
  if ($location eq $path) {
    push @{$hash{'.'}}, $location;
  } else {
    push @{$hash{$location}}, $name;
  }
}

foreach my $loc (keys %hash) {
   svnignore $loc, \@{$hash{$loc}};
}
