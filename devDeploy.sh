#!/bin/bash

# Look for modified stuff
printf "\033[0;34mDeploy\033[0m | Looking for git status...\n"
if [[ $(git status --porcelain) ]]; then
    printf "\033[0;33mDeploy\033[0m | You have git stuff to do. Fix before deploying.\n"
    exit 1
fi
printf "\033[0;32mDeploy\033[0m | Everything looks up to date.\n"

# Pull origin
printf "\033[0;34mDeploy\033[0m | Updating from origin...\n"
git fetch origin
git checkout main
PULL_OUTPUT=$(git pull origin main)

# Verificar si hubo cambios
if [[ "$PULL_OUTPUT" != *"Already up to date."* ]]; then
    printf "\033[0;33mDeploy\033[0m | There is new stuff. Execution continues."
fi

if [ $? -ne 0 ]; then
    printf "\033[0;31mDeploy\033[0m | Error while updating. You f* up something again.\n"
    exit 1
fi
printf "\033[0;32mDeploy\033[0m |Applied origin changes, if any.\n"

printf "

 █████╗ ███████╗███████╗██████╗ ██╗ █████╗
██╔══██╗╚══███╔╝██╔════╝██╔══██╗██║██╔══██╗
███████║  ███╔╝ █████╗  ██████╔╝██║███████║
██╔══██║ ███╔╝  ██╔══╝  ██╔══██╗██║██╔══██║
██║  ██║███████╗███████╗██║  ██║██║██║  ██║
╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝

Executing year-left, a BlueSky bot to know
how much time is left in the current year.\n
"

printf "\033[0;32mDeploy\033[0m | Loading .env variables..."
export $(grep -v '^#' .env | xargs)

printf "\033[0;32mDeploy\033[0m | Installing dependencies..."
npm install

printf "\033[0;32mDeploy\033[0m | Compiling TypeScript..."
npx tsc

printf "\033[0;32mDeploy\033[0m | Starting the service..."
npm start