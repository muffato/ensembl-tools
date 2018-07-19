#!/bin/bash -i

$1 mysqldump $2 | xz --best > $2.sql.xz

