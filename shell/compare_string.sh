#!/bin/env bash

# https://unix.stackexchange.com/questions/109625/shell-scripting-z-and-n-options-with-if
# https://blog.csdn.net/happylzs2008/article/details/94835646

[ ! -z $NOT_DEFINE ] && echo "is not null"
[ -n $NOT_DEFINE ] && echo "is not null"
[ -z $NOT_DEFINE ] && echo "is null"
[ ! -n $NOT_DEFINE ] && echo "is null"

[ ! -z "$NOT_DEFINE" ] && echo "is not null"
[ -n "$NOT_DEFINE" ] && echo "is not null"
[ -z "$NOT_DEFINE" ] && echo "is null"
[ ! -n "$NOT_DEFINE" ] && echo "is null"


DEFINED_STRING=""
[ ! -z $DEFINED_STRING ] && echo "is not null"
[ -n $DEFINED_STRING ] && echo "is not null"
[ -z $DEFINED_STRING ] && echo "is null"
[ ! -n $DEFINED_STRING ] && echo "is null"


[ ! -z "$DEFINED_STRING" ] && echo "is not null"
[ -n "$DEFINED_STRING" ] && echo "is not null"
[ -z "$DEFINED_STRING" ] && echo "is null"
[ ! -n "$DEFINED_STRING" ] && echo "is null"
