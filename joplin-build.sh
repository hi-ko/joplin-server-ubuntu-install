#!/bin/bash
# adapted from  https://github.com/laurent22/joplin/blob/dev/Dockerfile.server

cd /home/joplin

# Install the root scripts but don't run postinstall (which would bootstrap
# and build TypeScript files, but we don't have the TypeScript files at
# this point)

rm -f package*.json
cp joplin/package*.json ./
npm install --ignore-scripts

# To take advantage of the Docker cache, we first copy all the package.json
# and package-lock.json files, as they rarely change, and then bootstrap
# all the packages.
#
# Note that bootstrapping the packages will run all the postinstall
# scripts, which means that for packages that have such scripts, we need to
# copy all the files.
#
# We can't run boostrap with "--ignore-scripts" because that would
# prevent certain sub-packages, such as sqlite3, from being built

rm -rf packages
mkdir packages
rsync -r joplin/packages/fork-sax/package*.json ./packages/fork-sax/
rsync -r joplin/packages/htmlpack/package*.json ./packages/htmlpack/
rsync -r joplin/packages/renderer/package*.json ./packages/renderer/
rsync -r joplin/packages/tools/package*.json ./packages/tools/
rsync -r joplin/packages/lib/package*.json ./packages/lib/
rsync -r joplin/lerna.json .
rsync -r joplin/tsconfig.json .

# The following have postinstall scripts so we need to copy all the files.
# Since they should rarely change this is not an issue

rsync -r joplin/packages/turndown/ ./packages/turndown/
rsync -r joplin/packages/turndown-plugin-gfm/ ./packages/turndown-plugin-gfm/
rsync -r joplin/packages/fork-htmlparser2/ ./packages/fork-htmlparser2/

# Then bootstrap only, without compiling the TypeScript files

npm run bootstrap

# We have a separate step for the server files because they are more likely to
# change.

rsync -r joplin/packages/server/package*.json ./packages/server/
cp joplin/Assets/WebsiteAssets/favicon.ico ./packages/server/public/
npm run bootstrapServerOnly

# Now copy the source files. Put lib and server last as they are more likely to change.

rsync -r joplin/packages/fork-sax/ ./packages/fork-sax/
rsync -r joplin/packages/htmlpack/ ./packages/htmlpack/
rsync -r joplin/packages/renderer/ ./packages/renderer/
rsync -r joplin/packages/tools/ ./packages/tools/
rsync -r joplin/packages/lib/ ./packages/lib/
rsync -r joplin/packages/server/ ./packages/server/

# Finally build everything, in particular the TypeScript files.

npm run build
