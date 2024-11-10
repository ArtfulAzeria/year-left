#!/bin/bash

# Look for modified stuff
printf "🔵  | Looking for git status...\n"
if [[ $(git status --porcelain) ]]; then
    printf "🟡  | You have git stuff to do. Fix before deploying.\n"
    exit 1
fi
printf "🟢  |\033[0;32mEverything looks up to date.\033[0m\n"

printf "🔵  | Updating from origin...\n"
# Pull origin
git fetch origin
git checkout main
git pull origin main

if [ $? -ne 0 ]; then
    printf "🔴  | \033[0;31mError while updating. You f* up something again.\n"
    exit 1
fi
printf "🟢  |\033[0;32mApplied origin changes, if any.\033[0m\n"

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

printf "🔵  | Loading .env variables..."
export $(grep -v '^#' ../utils/year-left/.env | xargs)

printf "🔵  | Installing dependencies..."
npm install

printf "🔵  | Compiling TypeScript..."
npx tsc

printf "🔵  | Starting the service..."
npm start