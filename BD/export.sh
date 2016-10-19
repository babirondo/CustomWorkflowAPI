#!/bin/bash
pg_dump -h localhost -U bsiquei  customworkflow > dump.sql;
pg_dump -h localhost -U bsiquei customworkflow_prod > dump_prod.sql;
git add ../.;
git commit -m "$1";
git push;
cd ../../CustomWorkflow/;
git add .;
git commit -m "$1";
git push;
