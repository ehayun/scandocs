#!/usr/bin/bash
cd /home/eli/projects/scandocs

## - delete file more then 6 days

find ./priv/static/uploads -type f -name "*.png" -mtime +6 -exec rm -fr {} \;




