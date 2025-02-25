//
//  WeatherDetailsViewModel.swift
//  WeatherClientUIKit
//
//  Created by Ruslan Liulka on 17.02.2025.
//

import Foundation
import CoreData

class WeatherDetailsViewModel {
    
    private let network = NetworkManager.shared
    private let fileService: FileServiceProtocol
    private let coreData = CoreDataService.shared
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
    
    func saveWeatherCoreData(weather: WeatherResult) {
        
        let context = CoreDataService.shared.context
        
        let weatherObject = CDWeather(context: context)
        weatherObject.id = Int64(weather.id)
        weatherObject.name = weather.name
        weatherObject.date = Date()
        
        let coordObject = CDCoord(context: context)
        coordObject.id = Int64(weather.id)
        coordObject.lat = weather.coord.lat
        coordObject.lon = weather.coord.lon
        weatherObject.coord = coordObject
        
        let mainObject = CDMain(context: context)
        mainObject.id = Int64(weather.id)
        mainObject.temp = weather.main.temp
        mainObject.humidity = Int64(weather.main.humidity)
        mainObject.preasure = Int64(weather.main.pressure)
        weatherObject.main = mainObject
        
        let windObject = CDWind(context: context)
        windObject.id = Int64(weather.id)
        windObject.deg = Int64(weather.wind.deg)
        weatherObject.wind = windObject
        
        
        coreData.save(context: context)

    }

    
    func loadWeather() -> StoredWeatherData? {
        do {
            return try fileService.load(type: StoredWeatherData.self, fileName: fileName)
        } catch {
            print("Failled to load data", error)
            return nil
        }
       
    }
    
    func fetchSavedWeather() -> CDWeather? {
        let request: NSFetchRequest<CDWeather> = CDWeather.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        request.fetchLimit = 1
        
        let result = coreData.fetchDataFromEntity(CDWeather.self, fetchRequest: request)
        return result.first
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
