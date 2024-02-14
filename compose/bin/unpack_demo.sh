#!/usr/bin/env bash
if [ -f "./src-packed/$1/src.tgz" ]; then
    mkdir ./src
    tar -zxvf ./src-packed/$1/src.tgz -C ./src
fi
if [ -f "./src-packed/$1/mysql-dir.tgz" ]; then
    mkdir ./mysql-dir
    tar -zxvf ./src-packed/$1/mysql-dir.tgz -C ./mysql-dir
fi
