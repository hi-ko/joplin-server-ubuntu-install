#!/bin/bash
# adapted from  https://github.com/laurent22/joplin/blob/dev/Dockerfile.server

if [[ -f /etc/default/joplin ]];then
    . /etc/default/joplin
fi

GITDIR="${GITDIR:-$HOME/joplin}"
WORKDIR="${WORKDIR:-$HOME/build}"
JOPLIN_HOME="${JOPLIN_HOME:-/opt/joplin}"
SERVICE_NAME=joplin-server

COPY(){
    cd $WORKDIR
    SRC=$GITDIR/$1
    DEST=$2

    if [ ! -d $DEST ]; then
        mkdir -p $2
    fi
    if [ -d "$SRC" ]; then
        SRC="$SRC/"
    fi
    rsync -a $SRC $2/
}

checkout_latest(){
    GITDIR_PARENT=$(realpath $GITDIR/..)
    mkdir -p $GITDIR_PARENT && cd $GITDIR_PARENT
    if [ ! -d $GITDIR ];then
        git clone https://github.com/laurent22/joplin.git
    fi
    cd $GITDIR
    git fetch --tags
    latest=(`git describe --tags --match "server-*" --abbrev=0 $(git rev-list --tags --max-count=1)`)
    git checkout $latest
}

build(){
    cd $WORKDIR
    COPY .yarn/plugins ./.yarn/plugins
    COPY .yarn/releases ./.yarn/releases
    COPY package.json .
    COPY .yarnrc.yml .
    COPY yarn.lock .
    COPY gulpfile.js .
    COPY tsconfig.json .
    COPY packages/turndown ./packages/turndown
    COPY packages/turndown-plugin-gfm ./packages/turndown-plugin-gfm
    COPY packages/fork-htmlparser2 ./packages/fork-htmlparser2
    COPY packages/server/package*.json ./packages/server/
    COPY packages/fork-sax ./packages/fork-sax
    COPY packages/fork-uslug ./packages/fork-uslug
    COPY packages/htmlpack ./packages/htmlpack
    COPY packages/renderer ./packages/renderer
    COPY packages/tools ./packages/tools
    COPY packages/lib ./packages/lib
    COPY packages/server ./packages/server

    BUILD_SEQUENCIAL=1 yarn install --inline-builds \
        && yarn cache clean \
        && rm -rf .yarn/berry
}

install(){
        cd $WORKDIR/
        echo "installing packages to $JOPLIN_HOME/ ..."
        rsync -a --delete ./packages/ $JOPLIN_HOME/packages/
}

run(){
    APP_BASE_URL="${APP_BASE_URL:-https://joplin.me.org}"
    APP_PORT="${APP_PORT:-22300}"
    POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-joplin}"
    DB_CLIENT="${DB_CLIENT:-pg}"
    POSTGRES_DATABASE="${POSTGRES_DATABASE:-joplin}"
    POSTGRES_USER="${POSTGRES_USER:-joplin}"
    POSTGRES_PORT="${POSTGRES_PORT:-5432}"
    POSTGRES_HOST="${POSTGRES_HOST:-localhost}"
    RUNNING_IN_DOCKER=0
    
    MAILER_ENABLED="${MAILER_ENABLED:-0}"
    MAILER_HOST="${MAILER_HOST:-smtp.me.org}"
    MAILER_PORT="${MAILER_PORT:-465}"
    MAILER_SECURE="${MAILER_SECURE:-1}"
    MAILER_AUTH_USER="${MAILER_AUTH_USER:-me@me.org}"
    MAILER_AUTH_PASSWORD="${MAILER_AUTH_PASSWORD:-joplin}"
    MAILER_NOREPLY_EMAIL="${MAILER_NOREPLY_EMAIL:-me@me.org}"
    MAILER_NOREPLY_NAME="${MAILER_NOREPLY_NAME:-Joplin-Server}"

    export APP_BASE_URL APP_PORT DB_CLIENT POSTGRES_PASSWORD POSTGRES_DATABASE POSTGRES_USER POSTGRES_PORT POSTGRES_HOST RUNNING_IN_DOCKER MAILER_ENABLED MAILER_HOST MAILER_PORT MAILER_SECURE MAILER_AUTH_USER MAILER_AUTH_PASSWORD MAILER_NOREPLY_EMAIL MAILER_NOREPLY_NAME

    cd $JOPLIN_HOME
    mkdir -p logs
    npm --prefix packages/server start
}

case "$1" in
    checkout-latest)
        checkout_latest
        ;;
    build)
        build
        ;;
    install)
        install
        ;;
    makeall)
        if systemctl is-active $SERVICE_NAME > /dev/null ;then
            echo "$SERVICE_NAME still running as service - stop the service first"
            exit 1
        fi
        checkout_latest
        build
        install
        echo "DONE!"
        ;;
    run)
        if systemctl is-active $SERVICE_NAME > /dev/null ;then
            echo "$SERVICE_NAME still running as service - stop the service first"
            exit 1
        fi
        run
        ;;
    *)
        echo "Usage: $0 {checkout-latest|build|install|makeall|run}"
        exit 1
        ;;
esac
