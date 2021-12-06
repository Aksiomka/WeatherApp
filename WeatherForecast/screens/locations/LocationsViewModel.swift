//
//  LocationsViewModel.swift
//  WeatherForecast
//
//  Created by Svetlana Gladysheva on 03.12.2021.
//

import Foundation

protocol LocationsViewModelProtocol: ObservableObject {
    var locations: [LocationModel] { get }
    
    func loadData()
}

class LocationsViewModel: NSObject, ObservableObject {
    @Published var locations: [LocationModel] = []
    
    private let userDefaultsStorage: UserDefaultsStorageProtocol
    
    init(userDefaultsStorage: UserDefaultsStorageProtocol) {
        self.userDefaultsStorage = userDefaultsStorage
    }
}

extension LocationsViewModel: LocationsViewModelProtocol {
    func loadData() {
        locations = userDefaultsStorage.getLocations()
    }
}
