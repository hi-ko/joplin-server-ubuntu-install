cd /home/joplin

# Any variables defined in .joplinrc override the defaults below
if [[ -f .joplinrc ]];then
    . .joplinrc
fi

# URL configuration
# The server presents a web interface here
export APP_BASE_URL="${APP_BASE_URL:-https://joplin.me.org}"
export APP_PORT="${APP_PORT:-22300}"

# Database configuration
export POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-joplin}"
export DB_CLIENT="${DB_CLIENT:-pg}"
export POSTGRES_DATABASE="${POSTGRES_DATABASE:-joplin}"
export POSTGRES_USER="${POSTGRES_USER:-joplin}"
export POSTGRES_PORT="${POSTGRES_PORT:-5432}"
export POSTGRES_HOST="${POSTGRES_HOST:-localhost}"

# Email configuration
export MAILER_ENABLED="${MAILER_ENABLED:-1}"
export MAILER_HOST="${MAILER_HOST:-smtp.me.org}"
export MAILER_PORT="${MAILER_PORT:-465}"
export MAILER_SECURE="${MAILER_SECURE:-1}"
export MAILER_AUTH_USER="${MAILER_AUTH_USER:-me@me.org}"
export MAILER_AUTH_PASSWORD="${MAILER_AUTH_PASSWORD:-joplin}"
# Emails are sent "From:" this "name <email>"
# The account logged into MAILER_HOST as MAILER_AUTH_USER
# Must be authorised send emails "From: " this "name <email>"
export MAILER_NOREPLY_NAME="${MAILER_NOREPLY_NAME:-Joplin Server}"
export MAILER_NOREPLY_EMAIL="${MAILER_NOREPLY_EMAIL:-noreply@me.org}"

npm --prefix packages/server start
