//
//  LocationsFactory.swift
//  WeatherForecast
//
//  Created by Svetlana Gladysheva on 04.12.2021.
//

import Foundation

class LocationsFactory {
    func make() -> LocationsView<LocationsViewModel> {
        return LocationsView(viewModel: LocationsViewModel(userDefaultsStorage: UserDefaultsStorage()))
    }
}
