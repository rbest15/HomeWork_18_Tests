import Foundation

// MARK: - Weather
struct WeatherValue: Codable {
    let temp: Int
    let windSpeed: Double
    let windDir, precipitation: String
}

typealias Weather = [String: WeatherValue]
