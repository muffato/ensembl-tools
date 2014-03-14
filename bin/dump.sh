#!/bin/bash -i

mysql.d $1 $2 | xz --best > $2.sql.xz

