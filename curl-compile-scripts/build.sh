#!/bin/bash

REL_SCRIPT_PATH="$(dirname $0)"
SCRIPTPATH=$(realpath $REL_SCRIPT_PATH)
CURLPATH="$SCRIPTPATH/../curl"

if [ ! -x "$SCRIPTPATH/pre-configure.sh" ]; then
	echo "pre-configure.sh not found or not executable"
	exit 1;
fi

if [ -z "$NDK_ROOT" ]; then
  echo "Please set your NDK_ROOT environment variable first"
  exit 1
fi

PWD=$(pwd)
cd $SCRIPTPATH

if [ ! -f "$CURLPATH/Makefile" ]; then
	./pre-configure.sh

	EXITCODE=$?
	if [ $EXITCODE -ne 0 ]; then
		echo "Error running the pre-configure program"
		cd $PWD
		exit $EXITCODE
	fi
else
	echo "Omitting pre-configure.sh"
fi

if [ ! -f "$CURLPATH/lib/vtls/curl_setup.h" ]; then
  cd $CURLPATH/lib/vtls
  ln -s ../curl_setup.h
  cd $SCRIPTPATH
fi

$NDK_ROOT/ndk-build -C $SCRIPTPATH
EXITCODE=$?

rm "$CURLPATH/lib/vtls/curl_setup.h"

if [ $EXITCODE -ne 0 ]; then
	echo "Error running the ndk-build program"
	exit $EXITCODE
fi


#if [ ! -x "$(which wget)" ]; then
#  echo "You don't have wget installed, please install it and try again"
#  exit 1
#fi
