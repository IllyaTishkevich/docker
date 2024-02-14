#!/bin/bash

cd ./maker
./freewrap ../src/docker-helper.tcl -i ../src/docker-helper.ico ../help.docker -o ../../compose/bin/docker-helper
cd ..
chmod +X ../compose/bin/docker-helper
