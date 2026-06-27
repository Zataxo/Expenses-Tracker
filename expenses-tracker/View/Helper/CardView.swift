//
//  CardView.swift
//  expenses-tracker
//
//  Created by Hassan Abdalla on 08/01/1448 AH.
//

import SwiftUI

struct CardView: View {
    var income: Double
    var expense: Double
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(.background)
            //                .frame(width: .infinity, height: 100)
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Text(" \(currencyString(income - expense))")
                        .font(.title.bold())
                        .foregroundStyle(Color.primary)

                    Image(
                        systemName: expense > income
                            ? "chart.line.downtrend.xyaxis"
                            : "chart.line.uptrend.xyaxis"
                    )
                    .font(.title3)
                    .foregroundStyle(expense > income ? .red : .green)

                }.padding(.bottom, 25)

                HStack(spacing: 0) {

                    ForEach(CategoryModel.allCases, id: \.rawValue) {
                        category in

                        HStack(spacing: 10) {
                            Image(systemName: category.image)
                                .font(.callout.bold())
                                .foregroundStyle(category.tintColor)
                                .frame(width: 35, height: 35)
                                .background {
                                    Circle()
                                        .fill(
                                            category.tintColor.opacity(0.25)
                                                .gradient
                                        )

                                }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                
                                Text(category.rawValue)
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                                
                                
                                Text(currencyString(category == .income ? income : expense,allowedDigits: 0))
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.primary)

                            }
                            
                            (category == .income) ? Spacer(minLength: 10) : nil

                        }

                       

                    }

                }
            }
            .padding([.horizontal, .bottom], 20)
            .padding(.top,15)
        }
    }
}

#Preview {
    ScrollView {
        CardView(income: 4590, expense: 2389)
    }
}
