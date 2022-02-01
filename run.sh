#!/bin/bash
######################## 

if [[ -f .joplinrc ]];then
    . .joplinrc
fi

APP_BASE_URL="${APP_BASE_URL:-https://joplin.me.org}"
APP_PORT="${APP_PORT:-22300}"
DB_CLIENT="${DB_CLIENT:-pg}"
POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-joplin}"
POSTGRES_DATABASE="${POSTGRES_DATABASE:-joplin}"
POSTGRES_USER="${POSTGRES_USER:-joplin}"
POSTGRES_PORT="${POSTGRES_PORT:-5432}"
POSTGRES_HOST="${POSTGRES_HOST:-localhost}"

export APP_BASE_URL APP_PORT=22300 DB_CLIENT POSTGRES_PASSWORD POSTGRES_DATABASE POSTGRES_USER POSTGRES_PORT POSTGRES_HOST

cd /home/joplin

npm --prefix packages/server start
