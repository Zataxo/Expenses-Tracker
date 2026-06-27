//
//  TintColorModel.swift
//  expenses-tracker
//
//  Created by Hassan Abdalla on 08/01/1448 AH.
//

import SwiftUI

struct TintColorModel: Identifiable {
    let id: UUID = .init()
    let color: String
    let value: Color

}

 var tintColors: [TintColorModel] {
    [
        .init(color: "Red", value: .red),
        .init(color: "Blue", value: .blue),
        .init(color: "Pink", value: .pink),
        .init(color: "Purple", value: .purple),
        .init(color: "Brown", value: .brown),
        .init(color: "Orange", value: .orange),
    ]
}
