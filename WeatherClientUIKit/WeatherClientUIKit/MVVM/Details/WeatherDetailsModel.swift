//
//  WeatherDetailsModel.swift
//  WeatherClientUIKit
//
//  Created by Ruslan Liulka on 18.02.2025.
//
import Foundation

struct StoredWeatherData: Codable {
    let weather: WeatherResult
    let time: TimeInterval
}
