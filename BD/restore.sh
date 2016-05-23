#!/bin/bash
git pull
psql -c "drop database customworkflow" ; 
psql -f $1;


