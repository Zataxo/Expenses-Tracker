//
//  DateExt.swift
//  expenses-tracker
//
//  Created by Hassan Abdalla on 08/01/1448 AH.
//
import SwiftUI

extension Date {

    var startOfMonth: Date {
        let calendar = Calendar.current
        let component = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: component) ?? self
    }
    var endOfMonth: Date {
        let calendar = Calendar.current

        return calendar.date(byAdding: .init(month: 1, minute: -1),to: self.startOfMonth) ?? self
    }

}
