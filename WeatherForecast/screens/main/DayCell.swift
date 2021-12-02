//
//  DayCell.swift
//  WeatherForecast
//
//  Created by Svetlana Gladysheva on 21.11.2021.
//

import SwiftUI

struct DayCell: View {
    var model: ForecastForDayModel

    var body: some View {
        VStack(spacing: 2) {
            Text(model.date)
                .font(.system(size: 14.0))
            AsyncImage(url: model.iconUrl) { image in
                image.resizable()
            } placeholder: {
                Text("Loading...")
                    .font(.system(size: 10.0))
            }
                .frame(width: 50, height: 50)
            Text(model.temperatureDay)
                .font(.system(size: 28.0))
            Text(model.temperatureNight)
                .font(.system(size: 16.0))
                .foregroundColor(Color(white: 0.4))
            Spacer().frame(height: 6)
            Text(model.condition)
                .frame(height: 40)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .font(.system(size: 12.0))
                .foregroundColor(Color(white: 0.4))
        }
        .frame(width: 70)
    }
}

struct DayCell_Previews: PreviewProvider {
    static var previews: some View {
        DayCell(model: ForecastForDayModel(
            date: "Today",
            temperatureDay: "+10°",
            temperatureNight: "-2°",
            iconUrl: URL(string: ""),
            condition: "Sunny"
        ))
    }
}
