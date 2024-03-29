//
//  Calendar extension.swift
//  Timetable 3.0
//
//  Created by Konrad on 11/03/2021.
//  Copyright © 2021 Konrad. All rights reserved.
//

import Foundation

extension Calendar {
    
    func getNumberOfWeekDayOfName(_ name : String) -> Int {
        
        if name == "Sunday" {
            return 1
        }
        if name == "Monday" {
            return 2
        }
        if name == "Tuesday" {
            return 3
        }
        if name == "Wednesday" {
            return 4
        }
        if name == "Thursday" {
            return 5
        }
        if name == "Friday" {
            return 6
        }
        if name == "Saturday" {
            return 7
        }
        return 0
        
    }
    
    func getNameOfWeekDayOfNumber(_ number : Int) -> String {
        
        
        if number == 1 {
            return "Sunday"
        }
        if number == 2 {
            return "Monday"
        }
        if number == 3 {
            return "Tuesday"
        }
        if number == 4 {
            return "Wednesday"
        }
        if number == 5 {
            return "Thursday"
        }
        if number == 6 {
            return "Friday"
        }
        if number == 7 {
            return "Saturday"
        }
        return "Wrong data"
        
    }
    
    
    func getAppNumberOfWeekdayFromWeekday(_ number : Int) -> Int {
        
        if number == 1 {
            return 6
        }
        if number == 2 {
            return 0
        }
        if number == 3 {
            return 1
        }
        if number == 4 {
            return 2
        }
        if number == 5 {
            return 3
        }
        if number == 6 {
            return 4
        }
        if number == 7 {
            return 5
        }
        return 0
        
    }
}
