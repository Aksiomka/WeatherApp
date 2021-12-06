//
//  WeatherFactory.swift
//  WeatherForecast
//
//  Created by Svetlana Gladysheva on 02.12.2021.
//

import Foundation

class WeatherFactory {
    func make() -> WeatherView<WeatherViewModel> {
        return WeatherView(viewModel: WeatherViewModel(weatherService: WeatherService()))
    }
}
