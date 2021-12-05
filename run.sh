#!/bin/bash
######################## 

if [[ -f .joplinrc ]];then
    . .joplinrc
fi

APP_BASE_URL="${APP_BASE_URL:-https://joplin.me.org}"
APP_PORT="${APP_BASE_URL:-22300}"
DB_CLIENT="${APP_BASE_URL:-pg}"
POSTGRES_PASSWORD="${APP_BASE_URL:-joplin}"
POSTGRES_DATABASE="${APP_BASE_URL:-joplin}"
POSTGRES_USER="${APP_BASE_URL:-joplin}"
POSTGRES_PORT="${APP_BASE_URL:-5432}"
POSTGRES_HOST="${APP_BASE_URL:-localhost}"

export APP_BASE_URL APP_PORT=22300 DB_CLIENT POSTGRES_PASSWORD POSTGRES_DATABASE POSTGRES_USER POSTGRES_PORT POSTGRES_HOST

cd /home/joplin

npm --prefix packages/server start
