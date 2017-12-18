//
//  DateHelpers.swift
//  com.rideplanning
//
//  Created by Patrick Moniqui on 17-11-22.
//  Copyright © 2017 Patrick Moniqui. All rights reserved.
//

import Foundation

class DateHelpers
{
    static func stringToDate(dateString: String?) -> Date? {
        
        if dateString == nil {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateString!)
        return date ?? nil
    }
    
    static func dateToApiServiceString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    static func dateToString(date: Date, outputFormat: String = "") -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: date)
    }
    
    static func setDateOfDate(date: Date, newDate: Date) -> Date {
        let gregorian = Calendar(identifier: .gregorian)
        var _date = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        var _newDate = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: newDate)
        
        // Change the time to 9:30:00 in your locale
        _date.year = _newDate.year
        _date.month = _newDate.month
        _date.day = _newDate.day
        
        return gregorian.date(from: _date)!
    }
    
    static func setTimeOfDate(date: Date, newDate: Date) -> Date {
        let gregorian = Calendar(identifier: .gregorian)
        var _date = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        var _newDate = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: newDate)
        
        // Change the time to 9:30:00 in your locale
        _date.hour = _newDate.hour
        _date.minute = _newDate.minute
        _date.second = _newDate.second
        
        return gregorian.date(from: _date)!
    }
}
