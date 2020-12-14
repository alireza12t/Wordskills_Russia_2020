//
//  Date.swift
//  WordSkill-Alireza-Toghyiani-Iran
//
//  Created by ali on 9/19/20.
//  Copyright © 2020 ali. All rights reserved.
//

import UIKit


extension Date {
    
    func dateInfo(_ component: Calendar.Component) -> Int{
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        
        return calendar.component(component, from: self)
    }
    
    func timeToString() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let stringDate = formatter.string(from: self)
        return stringDate
    }
    
    func toDateString() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        let stringDate = formatter.string(from: self)
        return stringDate
    }
    
    func dayOfWeek() -> String{
        let day =  Calendar.current.dateComponents([.weekday], from: self).weekday!
        let dayName = DateFormatter().weekdaySymbols[(day-1) % 7]
        return dayName
    }
    

    func toiMessagesString() -> String{
        let now = Date()

        
        if self.dateInfo(.year) < now.dateInfo(.year) {
            return self.toDateString()
        } else {
            if self.dateInfo(.day) >= now.dateInfo(.day) - 7 {
                if self.dateInfo(.day) == now.dateInfo(.day) {
                    return self.timeToString()
                } else {
                    if now.dateInfo(.day) - self.dateInfo(.day) == 1{
                        return "Yesterday"
                    } else {
                        return self.dayOfWeek()
                    }
                }
            } else  {
                return self.toDateString()
            }
        }
    }
}
