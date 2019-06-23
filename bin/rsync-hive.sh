#!/bin/bash
rsync -ravH --delete "$@" ~/workspace/src/hive/schema/ ebi-sync-server:workspace/src/hive/schema/
