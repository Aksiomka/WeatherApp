//
//  AddLocationViewModel.swift
//  WeatherForecast
//
//  Created by Svetlana Gladysheva on 03.12.2021.
//

import Foundation
import MapKit

protocol AddLocationViewModelProtocol: ObservableObject {
    var centerCoordinate: CLLocationCoordinate2D { get set }
    func addLocation()
}

class AddLocationViewModel: NSObject, ObservableObject {
    @Published var centerCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    private let locationsStorage: LocationsStorageProtocol
    
    init(locationsStorage: LocationsStorageProtocol) {
        self.locationsStorage = locationsStorage
    }
    
}

extension AddLocationViewModel: AddLocationViewModelProtocol {
    func addLocation() {
        Task.detached(priority: .background) {
            let location = await self.createLocationModel(coordinate: self.centerCoordinate)
            await self.locationsStorage.addLocation(location)
        }
    }
}

private extension AddLocationViewModel {
    func createLocationModel(coordinate: CLLocationCoordinate2D) async -> LocationModel {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let placemarks = try? await geoCoder.reverseGeocodeLocation(location)
        let placeMark = placemarks?.first
        let city = placeMark?.subAdministrativeArea ?? "Unknown"
        let country = placeMark?.country ?? ""
    
        return LocationModel(city: city, country: country, lat: coordinate.latitude, lon: coordinate.longitude)
    }
}
