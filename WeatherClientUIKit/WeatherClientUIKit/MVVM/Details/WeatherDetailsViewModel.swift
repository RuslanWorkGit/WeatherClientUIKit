//
//  WeatherDetailsViewModel.swift
//  WeatherClientUIKit
//
//  Created by Ruslan Liulka on 17.02.2025.
//

import Foundation

class WeatherDetailsViewModel {
    
    private let network = NetworkManager.shared
    private let fileService: FileServiceProtocol
    private let fileName = "WeatherData.json"
    private let updateInterval: TimeInterval = 3 * 60 * 60 // 3 hours
    
    private var isUpdating = false
    
    init(fileService: FileServiceProtocol = FileService()) {
        self.fileService = fileService
    }
    
    func saveWeather(weather: StoredWeatherData) {
        do {
            try fileService.save(object: weather, fileName: fileName)
            print("Succesfull saved data")
        } catch {
            print("Failed to save data", error)
        } 
    }

    
    func loadWeather() -> StoredWeatherData? {
        do {
            return try fileService.load(type: StoredWeatherData.self, fileName: fileName)
        } catch {
            print("Failled to load data", error)
            return nil
        }
       
    }
    
    func shouldUpdateWeather(storedWeather: StoredWeatherData) -> Bool {
            let currentTime = Date().timeIntervalSince1970
            return (currentTime - storedWeather.time) > updateInterval
    }
    
        
    func fetchWeather(for city: String, completion: @escaping (WeatherResult?) -> Void) {
        network.fetchWeather(byCyti: city) { result in
            completion(result)
        }
    }
}
