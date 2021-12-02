//
//  CityWeatherCell.swift
//  WeatherForecast
//
//  Created by Svetlana Gladysheva on 14.11.2021.
//

import SwiftUI

struct CityWeatherCell: View {
    var model: WeatherModel

    var body: some View {
        VStack {
            Text(model.city)
                .font(.system(size: 20.0))
                .padding(EdgeInsets(top: 6, leading: 8, bottom: 0, trailing: 8))
            HStack {
                Text(model.currentTemperature)
                    .font(.system(size: 20.0))
                AsyncImage(url: model.currentIconUrl) { image in
                    image.resizable()
                } placeholder: {
                    Text("Loading...")
                        .font(.system(size: 10.0))
                }
                    .frame(width: 50, height: 50)
                Text(model.currentCondition)
                    .font(.system(size: 16.0))
            }
            Spacer().frame(height: 6)
            Color(white: 0.8).frame(height: 1)
            Spacer().frame(height: 18)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 10) {
                    ForEach(model.dailyForecasts, id: \.self) { forecast in
                        DayCell(model: forecast)
                    }
                }
            }
        }
        .padding()
        .background(
            Color.white
                .cornerRadius(8)
                .shadow(color: Color(white: 0.8), radius: 3)
        )
        .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
    }
}

struct WeatherCell_Previews: PreviewProvider {
    static var previews: some View {
        CityWeatherCell(model: WeatherModel(
            city: "Saint-Petersburg",
            currentTemperature: "25",
            currentIconUrl: URL(string: "10d"),
            currentCondition: "Cloudy",
            dailyForecasts: [
                .init(
                    date: "Today",
                    temperatureDay: "+12",
                    temperatureNight: "+3",
                    iconUrl: URL(string: ""),
                    condition: "Cloudy"
                ),
                .init(
                    date: "Tomorrow",
                    temperatureDay: "+14",
                    temperatureNight: "+8",
                    iconUrl: URL(string: ""),
                    condition: "Sunny"
                )
            ]
        ))
    }
}
