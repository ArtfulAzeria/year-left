#!/bin/bash

# Initialization
cd "$(dirname "$0")"
domain="bot.azeria.dev"
source ../utils/generic/formats.sh
error=false

# Default values for the flags
mode="dev"
account="none"
git="ignore"
log="info"

# Function to display usage information
function usage {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help                Show this help message and exit"
    echo "  -m, --mode <mode>         Set the mode (default: dev, options: dev, pro)"
    echo "  -a, --account <account>   Specify the account name (default: none)"
    echo "  -g, --git <action>        Git action (default: ignore, options: ignore, update)"
    echo "  -l, --log <level>         Log level (default: info, options: info, debug)"
    exit 0
}

# Function to perform git update if requested
function git_update {
    echo -e "year-left ${LOG_INFO} Checking for updates in Origin..."
    git fetch origin
    local updates=$(git diff origin/main)
    
    if [[ -n "$updates" ]]; then
        echo -e "year-left ${LOG_ERRR} Updates detected in the repository. Exiting..."
        exit 1
    else
        echo -e "year-left ${LOG_SCES} No updates found. Proceeding..."
    fi
}

# Parse options
while [[ $# -gt 0 ]]; do
    case "$1" in
    -h|--help)
        usage
        ;;
    -m|--mode)
        if [ -n "$2" ] && [[ "$2" != -* ]]; then
            mode="$2"
            if [[ "$mode" != "dev" && "$mode" != "pro" ]]; then
                echo -e "year-left ${LOG_ERRR} Error: Invalid mode. Use 'dev' or 'pro'."
                error=true
        fi
        else
            echo -e "year-left ${LOG_ERRR} Error: Missing argument for -m|--mode."
            error=true
        fi
        ;;
    -a|--account)
        if [ -n "$2" ] && [[ "$2" != -* ]]; then
            account="$2"
        else
            echo -e "year-left ${LOG_ERRR} Error: Missing argument for -a|--account."
            error=true
        fi
        ;;
    -g|--git)
        if [ -n "$2" ] && [[ "$2" != -* ]]; then
            git="$2"
            if [[ "$git" != "ignore" && "$git" != "update" ]]; then
                echo -e "year-left ${LOG_ERRR} Error: Invalid git option. Use 'ignore' or 'update'."
                error=true
            fi
        else
            echo -e "year-left ${LOG_ERRR} Error: Missing argument for -g|--git."
            error=true
        fi
        ;;
    -l|--log)
        if [ -n "$2" ] && [[ "$2" != -* ]]; then
            log="$2"
        else
            echo -e "year-left ${LOG_ERRR} Error: Missing argument for -l|--log."
            error=true
        fi
        ;;
    *)
        echo -e "year-left ${LOG_ERRR} Error: Unrecognized option '$1'"
        error=true
        ;;
    esac
    shift 1
    shift 1
done

if $error; then
    usage
    exit 1
fi

if [[ "$log" == "debug" ]]; then
    echo -e "year-left ${LOG_DBUG} Mode: $mode"
    echo -e "year-left ${LOG_DBUG} Account: $account"
    echo -e "year-left ${LOG_DBUG} Git action: $git"
    echo -e "year-left ${LOG_DBUG} Log level: $log"
fi

# Handle git update if the option is set to "update"
if [[ "$git" == "update" ]]; then
    git_update
fi

# Example logic based on the mode
if [[ "$mode" == "dev" ]]; then
    echo -e "year-left ${LOG_INFO} Running in development mode (dry run)."
else
    echo -e "year-left ${LOG_INFO} Running in production mode (posting live)."
fi




