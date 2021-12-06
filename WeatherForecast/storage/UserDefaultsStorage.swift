//
//  UserDefaultsStorage.swift
//  WeatherForecast
//
//  Created by Svetlana Gladysheva on 04.12.2021.
//

import Foundation

protocol UserDefaultsStorageProtocol {
    func getLocations() -> [LocationModel]
    func saveLocations(_ locations: [LocationModel])
    func addLocation(_ location: LocationModel)
}

class UserDefaultsStorage: UserDefaultsStorageProtocol {
    private let locationsKey = "locations"
    
    func getLocations() -> [LocationModel] {
        if let data = UserDefaults.standard.object(forKey: locationsKey) as? Data {
            return (try? JSONDecoder().decode([LocationModel].self, from: data)) ?? []
        }
        return []
    }
    
    func saveLocations(_ locations: [LocationModel]) {
        if let data = try? JSONEncoder().encode(locations) {
            UserDefaults.standard.set(data, forKey: locationsKey)
        }
    }
    
    func addLocation(_ location: LocationModel) {
        var locations = getLocations()
        locations.append(location)
        saveLocations(locations)
    }
}
