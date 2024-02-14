#!/usr/bin/env bash
if [ -f "./docker-compose.yml" ];then
  docker-compose stop
fi
if [ -d "./mysql-dir" ];then
  sudo chown $USER mysql-dir -R
  rm -rf mysql-dir/*
fi
if [ -d "./src" ];then
  sudo chown $USER src -R
  rm -rf src/* src/*.* src/.*
fi