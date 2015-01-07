#!/usr/bin/env bash

# $FILE - histcol.sh
# $AUTHOR - github/surojit-pathak
# $PURPOSE - Create your own command cheatsheet from bash history
# $LICENSE - Free

EXCL_CMD_LIST="clear cd cat chmod cp
               date diff dos2unix declare dmesg
               echo env exit
               ifconfig
               fg flake8
               grep generate_command_reference
               history hostname
               ls laracroft 
               man mkdir mv
               ping ps pwd printf python
               rm
               scp screen script sed source 
               touch
               vi
              "
EXCL_CMD_PTTRN=""
function build_excludelist ()
{
    for cmd in $EXCL_CMD_LIST
    do
        if [ "$EXCL_CMD_PTTRN" = "" ] ; then
            EXCL_CMD_PTTRN="^$cmd"
        else
            EXCL_CMD_PTTRN=$EXCL_CMD_PTTRN"\|^$cmd"
        fi
    done
}
build_excludelist
echo $EXCL_CMD_PTTRN

function laracroft ()
{
    history | sed 's/^.\{7\}//g' | sort | uniq | grep -v "$EXCL_CMD_PTTRN"
}

CMD_REF_FILE=`dirname "${BASH_SOURCE[0]}"`/command_reference
TEMP_FILE=/tmp/cmd_ref_temp_file
TEMP_FILE1=/tmp/cmd_ref_temp_file1
function generate_command_reference ()
{
     cat $CMD_REF_FILE > $TEMP_FILE
     laracroft >> $TEMP_FILE
     cat $TEMP_FILE | sort | uniq | grep -v "$EXCL_CMD_PTTRN" > $TEMP_FILE1
     # cat $TEMP_FILE1
     lc=`cat $TEMP_FILE1 | wc -l`
     lco=`cat $CMD_REF_FILE | wc -l`
     if [ $lc -gt $lco ] ; then
         mv -f $TEMP_FILE1 $CMD_REF_FILE
     fi 
     rm -f $TEMP_FILE
}       

