import { BskyAgent } from '@atproto/api';
const timeUtility = require('./utilities/time')
const graphicUtility = require('./utilities/graphic')

const args = process.argv.slice(2);
const accountArg = args.find(arg => arg.startsWith("--account="));
const account = accountArg ? accountArg.split('=')[1] : "default";
console.log(`Running with account: ${account}`);
console.log(__dirname+`/../../utils/${account}/.env`);
console.log(__dirname+'/../../utils/'+account+'/.env');

require('dotenv').config({ path: __dirname+'/../../utils/'+account+'/.env'});
console.log("debug#01");
console.log(process.env.BLUESKY_USERNAME);
console.log("debug#02");

const agent = new BskyAgent({
    service: "https://bsky.social"
})
console.log("debug#03");
async function main() {
    console.log("debug#04");
    await agent.login({ identifier: process.env.BLUESKY_USERNAME!, password: process.env.BLUESKY_PASSWORD! })
    console.log(process.env.BLUESKY_USERNAME);
    
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

    let post = `${graphicUtility.drawLine(timeLeft)} ${timeLeft}%\nDays left: ${year-day}/${year}`

    if (day === 1) {
        const newYear = "🤖 Happy new year, human! Hope you have an awesome year! 🎉\n"
        post = newYear + post
    }
    console.log("debug#05");
let postret = await agent.post({
        text: post
    });

    console.log(postret);
    console.log("_______________________________\n");
    console.log(postret.cid);
    console.log("_______________________________\n");
    console.log(postret.uri);
    
    console.log("Just posted!")
    
}
console.log("debug#06");
main();