//
//  WeatherModel.swift
//  WeatherForecast
//
//  Created by Svetlana Gladysheva on 14.11.2021.
//

import Foundation

struct CityCoordinates {
    let city: String
    let lat: Float
    let lon: Float
}

struct WeatherModel: Hashable {
    let city: String
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
