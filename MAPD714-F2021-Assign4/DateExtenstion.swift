//
//  DateExtention.swift
//  ToDoListAssign4
//
//  Created by Shirin Mansouri on 2021-11-08.
//

import Foundation



extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    static var dayAfterTomorrow:  Date { return Date().dayAfterTomorrow }
    static var dayBeforeYesterday:  Date { return Date().dayBeforeYesterday }
    var dayBefore: Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "EST")!
        return calendar.date(byAdding: .day, value: -1, to: self)!
    }
    var dayAfter: Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "EST")!
        return calendar.date(byAdding: .day, value: 1, to: self)!
    }
    var dayAfterTomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 2, to: self)!
    }
    var dayBeforeYesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -2, to: self)!
    }
    
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
