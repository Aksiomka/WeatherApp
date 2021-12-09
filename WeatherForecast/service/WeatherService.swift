//
//  WeatherService.swift
//  WeatherForecast
//
//  Created by Svetlana Gladysheva on 14.11.2021.
//

import Foundation

protocol WeatherServiceProtocol {
    func getForecast(lat: Double, lon: Double) async throws -> WeatherAPIModel
}

enum WeatherServiceError: Error {
    case invalidEndpoint
    case invalidResponse
    case parsingError
}

class WeatherService: WeatherServiceProtocol {
    private let urlString = "https://api.openweathermap.org/data/2.5/onecall"
    private let urlSession = URLSession.shared
    
    func getForecast(lat: Double, lon: Double) async throws -> WeatherAPIModel {
        guard
            let url = URL(string: urlString),
            let apiKey = getApiKey(),
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            throw WeatherServiceError.invalidEndpoint
        }
        
        let queryItems = [
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)"),
            URLQueryItem(name: "units", value: "metric")
        ]
        
        urlComponents.queryItems = queryItems
        
        guard let finalUrl = urlComponents.url else {
            throw WeatherServiceError.invalidEndpoint
        }
        
        let (data, response) = try await urlSession.data(from: finalUrl)
        
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw WeatherServiceError.invalidResponse
        }
        
        let jsonDecoder = JSONDecoder()
        do {
            return try jsonDecoder.decode(WeatherAPIModel.self, from: data)
        } catch {
            throw WeatherServiceError.parsingError
        }
    }
    
    static func constructImageUrl(icon: String) -> String {
        return "https://openweathermap.org/img/wn/\(icon)@2x.png"
    }
}

private extension WeatherService {
    struct Keys: Decodable {
        let weatherApiKey: String
    }
    
    private func getApiKey() -> String? {
        guard
            let keysUrl = Bundle.main.url(forResource: "Keys", withExtension:"plist"),
            let data = try? Data(contentsOf: keysUrl),
            let keys = try? PropertyListDecoder().decode(Keys.self, from: data)
        else {
            return nil
        }
            
        return keys.weatherApiKey
    }
}
