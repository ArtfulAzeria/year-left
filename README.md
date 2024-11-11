# @year-left.bot.azeria.dev

This is the source code for a [BlueSky](https://bsky.app/) bot called [@year-left.bot.azeria.dev](https://bsky.app/profile/year-left.bot.azeria.dev).
The bot is based on [michaellee](https://github.com/michaellee) work with [his year-left bot](https://github.com/michaellee/year-left) for Twitter.

## How to use it
If you want to host the bot you will need a unix based server (or WSL for windows) since scripts are written for bash. Alternativelly, you can
create your own startup script. If you have the infrastructure to run it, just clone the repo and make sure to create a .env file for your
BlueSky credentials.

To get the credentials go to your BlueSky account. [Settings > App Passwords](https://bsky.app/settings/app-passwords).
Then, generate your .env file like this:

BLUESKY_USERNAME=here.goes.your.bluesky.handle.without.the.@
BLUESKY_PASSWORD=here.goes.the.password.you.just.created

For obvious security reasons, my .env is not uploaded to git, and neither should yours. Don't worry, this should not happen since is addded to the .gitignore file.

The deploy.sh script loads the .env file from the route `../utils/year-left/.env`. Make sure to have this route avaible. If you prefer other place to store your
enviroment variables, just change the route on the `deploy.sh` file.

If you got here, you should be able to already make a post executing manually the deploy.sh file.

For automation I just use cron. My configuration is a post a day like this:
`0 0 * * * /usr/bin/bash /your/route/to/repository/deploy.sh >> /your/route/to/repository/utils/year-left/year-left.log 2>&1`
This will execute the script and save a log with the output on `/utils/year-left/year-left.log`.

`deploy.sh` sets a relative route to execute the next commands (so cron can run it properly), looks for changes on the origin git, and finally executes the app.
If you feel like some of this steps are not needed, feel free to modify to your liking the `deploy.sh` file.

**Warning**: even though it looks for changes on origin, it does not apply them fully on the execution, at least not to the `deploy.sh` itself, since is already being run.

**Warning**: base behavior is to stop execution if there are modified files not uploaded to git. This can be commented for test purposes.

Future development might address this warnings with some QOL updates.

**Extra Warning**: Bear in mind that you need a private server to run this, or pretty much any bot with limitations on API requests. Trying to run the service trough GitHub actions was my first thought, but it just gives you [Rate Limit errors](https://github.com/ArtfulAzeria/year-left/actions/runs/11759268487/job/32758552552), since your rate limit for requests is being capped on the IP that GitHub is trying to run the action through.