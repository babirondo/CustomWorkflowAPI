#!/bin/bash
git pull
psql -c "drop database customworkflow" ;
psql -c "create database customworkflow";
psql -c "\c customworkflow"; 
psql -f $1;


