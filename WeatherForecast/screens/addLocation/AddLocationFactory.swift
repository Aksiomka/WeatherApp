//
//  AddLocationFactory.swift
//  WeatherForecast
//
//  Created by Svetlana Gladysheva on 05.12.2021.
//

import Foundation

class AddLocationFactory {
    func make() -> AddLocationView<AddLocationViewModel> {
        return AddLocationView(viewModel: AddLocationViewModel(userDefaultsStorage: UserDefaultsStorage()))
    }
}
