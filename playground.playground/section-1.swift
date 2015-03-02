// Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

var a = 20/10


var dic = ["a": 1, "b": 3]

var b: AnyObject = dic as AnyObject

var string = 50 + (arc4random() % (100 - 50 + 1))


//srandom(time(0))
//var i = random()


Int(arc4random() % 2)

time(nil)
var now = time(nil)

now - (now % 86400)

var calendar: NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
var dateComponents = calendar.components(NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit | NSCalendarUnit.WeekdayCalendarUnit, fromDate: NSDate())
dateComponents.year
dateComponents.month
dateComponents.day
dateComponents.hour
dateComponents.minute
dateComponents.second

//Week:
//1 －－星期天
//2－－星期一
//3－－星期二
//4－－星期三
//5－－星期四
//6－－星期五
//7－－星期六
var week = dateComponents.weekday

if week < 0 {
    week = week + 7
}


var seconds = 1

NSString(format: "%.5f", pow(Float(seconds), 0.5))

//import RSA
//var test: NSString = [RSA encryptString:@"hello world!" publicKey:pubkey];
//NSLog(@"encrypted: %@", ret);


var dfa = 23.323
var cdf = "\(dfa)" as NSString
cdf.floatValue

Int(3.9)





















