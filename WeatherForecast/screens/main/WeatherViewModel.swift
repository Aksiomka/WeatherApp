//
//  WeatherViewModel.swift
//  WeatherForecast
//
//  Created by Svetlana Gladysheva on 14.11.2021.
//

import Foundation

protocol WeatherViewModelProtocol: ObservableObject {
    var lastUpdated: String { get }
    var models: [WeatherModel] { get }
    var errorMessage: String? { get }
    var isEmptyLocations: Bool { get }
    
    func updateData()
}

class WeatherViewModel: NSObject, ObservableObject {
    @Published var lastUpdated = "Never"
    @Published var models: [WeatherModel] = []
    @Published var errorMessage: String?
    @Published var isEmptyLocations = false
    
    private let weatherService: WeatherServiceProtocol
    private let locationsStorage: LocationsStorageProtocol
    
    init(weatherService: WeatherServiceProtocol, locationsStorage: LocationsStorageProtocol) {
        self.weatherService = weatherService
        self.locationsStorage = locationsStorage
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(locationsChanged), name: LocationsStorage.locationChangedNotificationName, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension WeatherViewModel: WeatherViewModelProtocol {
    func updateData() {
        Task {
            let locations = await self.locationsStorage.getLocations()
            await MainActor.run {
                self.isEmptyLocations = locations.isEmpty
            }
            if locations.isEmpty {
                return
            }
            
            do {
                let forecasts = try await withThrowingTaskGroup(of: WeatherModel.self, returning: [WeatherModel].self) { group in
                    for location in locations {
                        group.addTask {
                            let forecast = try await self.weatherService.getForecast(lat: location.lat, lon: location.lon)
                            return self.convertForecast(forecast, locationName: "\(location.city), \(location.country)")
                        }
                    }
                    
                    return try await group.reduce(into: [WeatherModel]()) { result, model in
                        result.append(model)
                    }
                }
                
                await MainActor.run {
                    self.models = forecasts
                    self.errorMessage = nil
                    self.lastUpdated = self.formatDateTime(Date())
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "An error occured while downloading data"
                }
            }
        }
    }
}

private extension WeatherViewModel {
    func convertForecast(_ forecast: WeatherAPIModel, locationName: String) -> WeatherModel {
        return WeatherModel(
            locationName: locationName,
            currentTemperature: formatTemperature(forecast.current.temp),
            currentIconUrl: constructIconUrl(icon: forecast.current.weather[0].icon),
            currentCondition: forecast.current.weather[0].description,
            dailyForecasts: forecast.daily.map { convertDailyForecast($0) }
        )
    }
    
    func convertDailyForecast(_ forecast: Daily) -> ForecastForDayModel {
        return ForecastForDayModel(
            date: convertDate(forecast.dt),
            temperatureDay: formatTemperature(forecast.temp.day),
            temperatureNight: formatTemperature(forecast.temp.night),
            iconUrl: constructIconUrl(icon: forecast.weather[0].icon),
            condition: forecast.weather[0].description
        )
    }
    
    func convertDate(_ dt: Int64) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        return formatDate(date, dateFormat: "dd MMM")
    }
    
    func formatTemperature(_ temperature: Float) -> String {
        let prefix = temperature > 0 ? "+" : ""
        return "\(prefix)\(Int(temperature.rounded()))°"
    }
    
    func formatDateTime(_ date: Date) -> String {
        return formatDate(date, dateFormat: "dd MMM yyyy HH:mm")
    }
    
    func formatDate(_ date: Date, dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
    
    func constructIconUrl(icon: String) -> URL? {
        return URL(string: WeatherService.constructImageUrl(icon: icon))
    }
    
    @objc func locationsChanged() {
        updateData()
    }
}
