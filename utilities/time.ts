function calculateTimeLeft (dayOfYear:number, daysInYear:number) {
    return Math.ceil((1 - (dayOfYear / daysInYear)) * 100)
}

function calculateTimeLeftYesterday (dayOfYear:number, daysInYear:number) {
    return Math.ceil((1 - ((dayOfYear - 1) / daysInYear)) * 100)
}

function isLeapYear (year:number) {
    return ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);
}

module.exports = {
    calculateTimeLeft: calculateTimeLeft,
    calculateTimeLeftYesterday: calculateTimeLeftYesterday,
    isLeapYear: isLeapYear
}