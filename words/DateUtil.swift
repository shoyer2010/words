//
//  Date.swift
//  words
//
//  Created by shoyer on 15/2/28.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

import Foundation


struct DateUtil {
    static let DAYS_60 = 5184000
    static let DAYS_30 = 2592000
    static let DAYS_10 = 864000
    static let DAYS_1 = 86400
    
    static func startOfThisDay() -> Int {
        var now = time(nil)
        
        return now - (now % 86400)
    }
    
    static func startOfThisWeek() -> Int {
        var now = time(nil)
        
        var calendar: NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        var dateComponents = calendar.components(NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit | NSCalendarUnit.WeekdayCalendarUnit, fromDate: NSDate())
        
        var weekDay = dateComponents.weekday - 2 // 0 is Monday 6 is Sunday
        if weekDay < 0 {
            weekDay += 7
        }
        
        var monday = now - 86400 * weekDay
        return monday - (monday % 86400)
    }
    
    static func startOfThisMonth() -> Int {
        var now = time(nil)
        
        var calendar: NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        var dateComponents = calendar.components(NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit | NSCalendarUnit.WeekdayCalendarUnit, fromDate: NSDate())
        
        var day = dateComponents.day - 1 // 0 is the first day
        
        var firstDay = now - 86400 * day
        return firstDay - (firstDay % 86400)
    }
    
    static func standardDate(timestamp: Int) -> String {
        var calendar: NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        var dateComponents = calendar.components(NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit | NSCalendarUnit.WeekdayCalendarUnit, fromDate: NSDate(timeIntervalSince1970: NSTimeInterval(timestamp)))
        
        var month = ""
        if (dateComponents.month < 10) {
            month = "0\(dateComponents.month)"
        } else {
            month = "\(dateComponents.month)"
        }
        
        var day = ""
        if (dateComponents.day < 10) {
            day = "0\(dateComponents.day)"
        } else {
            day = "\(dateComponents.day)"
        }
        
        return "\(dateComponents.year)-\(month)-\(day)"
    }
}