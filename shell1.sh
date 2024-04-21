#!/bin/bash

#------------------ Shell scripting parameters ----------------

echo The script name is $0
echo The first argument is $1
echo The second argument is $2
echo The third argument is $3
echo \$ $$ PID of script
echo \# $# Total number of arguments

#-------------- Shell Scripting Shift command -------------------

 if [ "$#" == "0" ]
  then
  echo pass at least one parameter.
  exit 1
 fi
 while (( $# ))
 do 
   echo you gave me $1
   shift
 done 

#------------------ Read command ------------------------

echo Enter your name :
read name
echo Enter your contact details :
read cdatails
