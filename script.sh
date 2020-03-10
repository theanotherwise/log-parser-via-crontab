#!/bin/bash

SCRIPT_PATH=`readlink -f $0`
SCRIPT_DIR=`dirname $SCRIPT_PATH`

VARLOG_DIR=/var/log

[ ! -d "$SCRIPT_DIR" ] && exit

FILT=$SCRIPT_DIR/.monitor.filtered
COMP=$SCRIPT_DIR/.monitor.compared

touch $FILT $COMP

DEFAULT_GRAB="error|critical|warn"

grep -iE "$DEFAULT_GRAB" $VARLOG_DIR/kern.log >> $FILT 2>/dev/null
grep -iE "$DEFAULT_GRAB" $VARLOG_DIR/boot.log >> $FILT 2>/dev/null
grep -iE "$DEFAULT_GRAB" $VARLOG_DIR/auth.log >> $FILT 2>/dev/null
grep -iE "$DEFAULT_GRAB" $VARLOG_DIR/dpkg.log >> $FILT 2>/dev/null

RES=`diff $FILT $COMP`
cat $FILT > $COMP

rm -f $FILT

[ -n "$RES" ] && echo -ne "$RES"