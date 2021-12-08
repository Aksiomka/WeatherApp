//
//  WeatherModel.swift
//  WeatherForecast
//
//  Created by Svetlana Gladysheva on 14.11.2021.
//

import Foundation

struct WeatherModel: Hashable {
    let locationName: String
    let currentTemperature: String
    let currentIconUrl: URL?
    let currentCondition: String
    let dailyForecasts: [ForecastForDayModel]
}

struct ForecastForDayModel: Hashable {
    let date: String
    let temperatureDay: String
    let temperatureNight: String
    let iconUrl: URL?
    let condition: String
}
