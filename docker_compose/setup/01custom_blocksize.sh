#!/bin/sh

echo "Environment: $(uname -a)";

sysresv

sqlplus / "as sysdba" <<EOF
SET SERVEROUTPUT ON;
ALTER SYSTEM SET DB_32K_CACHE_SIZE = 256M SCOPE = SPFILE;

SHUTDOWN IMMEDIATE;
STARTUP;

SHOW PARAMETER db_32k_cache_size;
EOF
