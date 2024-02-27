#!/usr/bin/env bash
echo This script run 2 shells in the screen command for Falcon Server and Falcon Client
echo 
echo Ctrl+a Tab - change shell
echo Ctrl+c - Close current shell
echo 
echo
echo connect to Falcon PWA - https://local.magento2.com:3000/
echo 
echo Press Enter to start.
read x

docker-compose exec nodejs screen
