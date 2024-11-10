import { BskyAgent } from '@atproto/api';
import * as dotenv from 'dotenv';
const timeUtility = require('./utilities/time')
const graphicUtility = require('./utilities/graphic')

dotenv.config();

const agent = new BskyAgent({
    service: 'https://bsky.social'
})

async function main() {
    await agent.login({ identifier: process.env.BLUESKY_USERNAME!, password: process.env.BLUESKY_PASSWORD! })

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
        const newYear = `🤖 Happy new year, human! Hope you have an awesome year! 🎉\n`
        post = newYear + post
    }

    await agent.post({
        text: post
    });


    console.log("Just posted!")
}

main();