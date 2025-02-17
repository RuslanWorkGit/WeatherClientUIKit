//
//  WeatherViewModel.swift
//  WeatherClientUIKit
//
//  Created by Ruslan Liulka on 15.02.2025.
//

import Foundation

class WeatherViewModel {
    
    private let networkManager = NetworkManager.shared
    private let fileName = "WeatherData.json"
    
    private let fileService: FileServiceProtocol
    
    init(fileService: FileServiceProtocol = FileService()) {
        self.fileService = fileService
    }
    
    var updateWeatherInfo: ((WeatherResult) -> Void)?
    
    
    
    var selectedSegment: Int = 0 {
        didSet {
            segmentChanged?(selectedSegment)
        }
    }
    
    var segmentChanged: ((Int) -> Void)?
    
    func fetchByCity(withCity city: String) {
        networkManager.fetchWeather(byCyti: city) { [weak self] result in
            DispatchQueue.main.async {
                self?.updateWeatherInfo?(result)
            }
        }
    }
    
    func fetchByCoordinate(latitude: String, longitude: String) {
        networkManager.fetchWeather(byLatitude: latitude, byLongitude: longitude) { [ weak self ] result in
            DispatchQueue.main.async {
                self?.updateWeatherInfo?(result)
            }
        }
    }
    
    func saveData() {
        
    }
    
    func loadData() {
        
    }
    
}
