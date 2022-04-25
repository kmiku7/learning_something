#!/bin/env bash

# https://unix.stackexchange.com/questions/109625/shell-scripting-z-and-n-options-with-if

[ ! -z $NOT_DEFINE ] && echo "is not null"
[ -n $NOT_DEFINE ] && echo "is not null"
[ -z $NOT_DEFINE ] && echo "is null"
[ ! -n $NOT_DEFINE ] && echo "is null"


[ ! -z "$NOT_DEFINE" ] && echo "is not null"
[ -n "$NOT_DEFINE" ] && echo "is not null"
[ -z "$NOT_DEFINE" ] && echo "is null"
[ ! -n "$NOT_DEFINE" ] && echo "is null"
