#!/bin/bash
pg_dump -h localhost -U bsiquei  -C  customworkflow > dump.sql;
ls -lah dump.sql;
git add ../.;
git commit -m "$1";
git push;
cd ../../CustomWorkflow/;
git add .;
git commit -m "$1";
git push;
