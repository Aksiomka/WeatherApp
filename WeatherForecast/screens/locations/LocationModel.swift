//
//  LocationModel.swift
//  WeatherForecast
//
//  Created by Svetlana Gladysheva on 03.12.2021.
//

import Foundation

struct LocationModel: Hashable, Codable {
    let city: String
    let country: String
    let lat: Double
    let lon: Double
}
