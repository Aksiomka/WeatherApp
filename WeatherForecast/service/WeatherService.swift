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
    private let apiKey = "6a8ec1ad1aec9e15884fee8d51172da7"
    private let urlString = "https://api.openweathermap.org/data/2.5/onecall"
    
    private let urlSession = URLSession.shared
    
    func getForecast(lat: Double, lon: Double) async throws -> WeatherAPIModel {
        guard let url = URL(string: urlString), var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
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
