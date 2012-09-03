#!/bin/bash

cd ..
MASTERMIND_ROOT=`pwd`
cd Build

BUILD_ID=$USER
PATH=$PATH:$MASTERMIND_ROOT/Build

export MASTERMIND_ROOT
export BUILD_ID
export PATH

