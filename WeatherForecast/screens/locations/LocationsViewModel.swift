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
    func deleteLocations(at indexes: IndexSet)
}

class LocationsViewModel: NSObject, ObservableObject {
    @Published var locations: [LocationModel] = []
    
    private let locationsStorage: LocationsStorageProtocol
    
    init(locationsStorage: LocationsStorageProtocol) {
        self.locationsStorage = locationsStorage
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(locationsChanged), name: LocationsStorage.locationChangedNotificationName, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension LocationsViewModel: LocationsViewModelProtocol {
    func loadData() {
        Task {
            let locations = await locationsStorage.getLocations()
            await MainActor.run {
                self.locations = locations
            }
        }
    }
    
    func deleteLocations(at indexes: IndexSet) {
        Task {
            for index in indexes {
                if index >= 0 && index < locations.count {
                    let location = locations[index]
                    await locationsStorage.deleteLocation(location)
                }
            }
        }
    }
}

private extension LocationsViewModel {
    @objc func locationsChanged() {
        loadData()
    }
}
