#!/bin/bash
echo "Pulling lecture slides from studres...";

rsync -azP --verbose --human-readable gs248@gs248.teaching.cs.st-andrews.ac.uk:/cs/studres/CS2003/ ~/Documents/University/St\ Andrews/CS/CS2003/;

rsync -azP --verbose --human-readable gs248@gs248.teaching.cs.st-andrews.ac.uk:/cs/studres/CS2001/ ~/Documents/University/St\ Andrews/CS/CS2001/;

rsync -azP --verbose --human-readable gs248@gs248.teaching.cs.st-andrews.ac.uk:/cs/studres/CS2002/ ~/Documents/University/St\ Andrews/CS/CS2002/;

