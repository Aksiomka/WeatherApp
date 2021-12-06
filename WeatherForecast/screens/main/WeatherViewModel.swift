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
    
    func updateData()
}

class WeatherViewModel: NSObject, ObservableObject {
    let cityCoordinatesList = [
        CityCoordinates(city: "Kudrovo", lat: 59.899720, lon: 30.516929),
        CityCoordinates(city: "Barnaul", lat: 53.347285, lon: 83.789271),
        CityCoordinates(city: "Berlin", lat: 52.518621, lon: 13.375142),
        CityCoordinates(city: "Irvine", lat: 33.670582, lon: -117.780920)
    ]
    
    @Published var lastUpdated = "Never"
    @Published var models: [WeatherModel] = []
    @Published var errorMessage: String?
    
    private let weatherService: WeatherServiceProtocol
    
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }
}
 
extension WeatherViewModel: WeatherViewModelProtocol {
    func updateData() {
        Task.detached(priority: .background) {
            do {
                let forecasts = try await withThrowingTaskGroup(of: WeatherModel.self, returning: [WeatherModel].self) { group in
                    for cityCoordinates in self.cityCoordinatesList {
                        group.addTask {
                            let forecast = try await self.weatherService.getForecast(lat: cityCoordinates.lat, lon: cityCoordinates.lon)
                            return self.convertForecast(forecast, city: cityCoordinates.city)
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
    func convertForecast(_ forecast: WeatherAPIModel, city: String) -> WeatherModel {
        return WeatherModel(
            city: city,
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: date)
    }
    
    func formatTemperature(_ temperature: Float) -> String {
        let prefix = temperature > 0 ? "+" : ""
        return "\(prefix)\(Int(temperature.rounded()))°"
    }
    
    func formatDateTime(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func constructIconUrl(icon: String) -> URL? {
        return URL(string: WeatherService.constructImageUrl(icon: icon))
    }
}
