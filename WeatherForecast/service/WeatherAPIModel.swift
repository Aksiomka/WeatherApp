//
//  WeatherAPIModel.swift
//  WeatherForecast
//
//  Created by Svetlana Gladysheva on 14.11.2021.
//

import Foundation

struct WeatherAPIModel: Decodable {
    let lat: Float
    let lon: Float
    let timezone: String
    let current: Current
    let daily: [Daily]
}

struct Current: Decodable {
    let dt: Int64
    let temp: Float
    let weather: [Weather]
}

struct Daily: Decodable {
    let dt: Int64
    let temp: DailyTemperature
    let weather: [Weather]
}

struct Weather: Decodable {
    let description: String
    let icon: String
}

struct DailyTemperature: Decodable {
    let day: Float
    let night: Float
}
