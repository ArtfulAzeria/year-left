import { BskyAgent } from '@atproto/api';
const timeUtility = require('./utilities/time')
const graphicUtility = require('./utilities/graphic')
const style = require('./utilities/style')

console.log(`${style.log.DBUG} Loading variables...`);
// Default values
const DEFAULTS = {
    account: "devnull",  // Available options: "devnull", "yaer-left"
    mode: "dev",         // Available options: "dev", "pro"
    log: "info"          // Available options: "debug", "info"
};

// Parse command line arguments
const args = process.argv.slice(2);

// Function to extract the value from arguments
function getArgValue(flag: string): string | undefined {
    const arg = args.find(arg => arg.startsWith(`--${flag}=`));
    return arg ? arg.split("=")[1] : undefined;
}

// Extract values or use defaults
const account = getArgValue("account") || DEFAULTS.account;
const mode = getArgValue("mode") || DEFAULTS.mode;
const log = getArgValue("log") || DEFAULTS.log;

// Log the extracted arguments
if (log=="debug") {
    console.log(`${style.log.DBUG} Account: ${account}`);
    console.log(`${style.log.DBUG} Mode: ${mode}`);
    console.log(`${style.log.DBUG} Log Level: ${log}`);
}

// Load credentials
require('dotenv').config({ path: __dirname + '/../../utils/' + account + '/.env' });
const agent = new BskyAgent({
    service: "https://bsky.social"
})
if (log=="debug") {
    console.log(`${style.log.DBUG} BLUESKY_USERNAME: ${process.env.BLUESKY_USERNAME!}`);
    console.log(`${style.log.DBUG} BLUESKY_PASSWORD: ${process.env.BLUESKY_PASSWORD!.replace(/[a-zA-Z0-9]/g, '*')}`);
}

async function main() {
    console.log(`${style.log.DBUG} Loging in...`);
    await agent.login({ identifier: process.env.BLUESKY_USERNAME!, password: process.env.BLUESKY_PASSWORD! })

    console.log(`${style.log.DBUG} Generating the post...`);
    let now: Date = new Date();
    let start: Date = new Date(now.getFullYear(), 0, 0);

    let year: number = 365;
    let currentYear: number = now.getFullYear();

    if (timeUtility.isLeapYear(currentYear)) {
        year = 366;
    }

    let diff: number = now.getTime() - start.getTime();

    let oneDay: number = 1000 * 60 * 60 * 24;
    let day: number = Math.floor(diff / oneDay);

    let timeLeft: number = timeUtility.calculateTimeLeft(day, year);
    let yesterday: number = timeUtility.calculateTimeLeftYesterday(day, year)

    // let override: = process.argv[2] || false

    let post = `${graphicUtility.drawLine(timeLeft)} ${timeLeft}%\nDays left: ${year - day}/${year}`

    if (day === 1) {
        console.log(`${style.log.INFO} Happy new year!`);
        const newYear = "🤖 Happy new year, human! Hope you have an awesome year! 🎉\n"
        post = newYear + post
    }
    
    console.log(`${style.log.DBUG} Ready to post.`);
    var response: Object = "";
    if (mode=="pro") {
        response = await agent.post({
            text: post
        });
    }

    response?
        console.log(`${style.log.INFO} Post made. Return data:\n${JSON.stringify(response, null, 2)}`):
        console.log(`${style.log.WARN} Post not made.`);
}

main();