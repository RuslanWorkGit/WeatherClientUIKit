//
//  WeatherDetailsViewModel.swift
//  WeatherClientUIKit
//
//  Created by Ruslan Liulka on 17.02.2025.
//

import Foundation

class WeatherDetailsViewModel {
    
    
    private let fileService: FileServiceProtocol
    private let fileName = "WeatherData.json"
    
    var weatherData: WeatherResult?
    
    init(fileService: FileServiceProtocol = FileService()) {
        self.fileService = fileService
    }
    
    func saveWeather() {
        guard let weather = weatherData else { return }
        
        do {
            try fileService.save(object: weather, fileName: fileName)
            print("Succesfull saved data")
        } catch {
            print("Failed to save data", error)
        }
        
    }

    
    func loadWeather() {
        do {
            weatherData = try fileService.load(type: WeatherResult.self, fileName: fileName)
        } catch {
            print("Failled to load data", error)
            weatherData = nil
        }
       
    }
}
