//
//  LocationsStorage.swift
//  WeatherForecast
//
//  Created by Svetlana Gladysheva on 04.12.2021.
//

import Foundation

protocol LocationsStorageProtocol {
    func getLocations() async -> [LocationModel]
    func saveLocations(_ locations: [LocationModel]) async
    func addLocation(_ location: LocationModel) async
    func deleteLocation(_ location: LocationModel) async
}

class LocationsStorage: LocationsStorageProtocol {
    static let locationChangedNotificationName = Notification.Name("locationsChanged")
    
    private let locationsKey = "locations"
    
    func getLocations() async -> [LocationModel] {
        if let data = UserDefaults.standard.object(forKey: locationsKey) as? Data {
            return (try? JSONDecoder().decode([LocationModel].self, from: data)) ?? []
        }
        return []
    }
    
    func saveLocations(_ locations: [LocationModel]) async {
        if let data = try? JSONEncoder().encode(locations) {
            UserDefaults.standard.set(data, forKey: locationsKey)
            NotificationCenter.default.post(name: LocationsStorage.locationChangedNotificationName, object: nil)
        }
    }
    
    func addLocation(_ location: LocationModel) async {
        var locations = await getLocations()
        locations.append(location)
        await saveLocations(locations)
    }
    
    func deleteLocation(_ location: LocationModel) async {
        var locations = await getLocations()
        locations.removeAll(where: { $0 == location })
        await saveLocations(locations)
    }
}
