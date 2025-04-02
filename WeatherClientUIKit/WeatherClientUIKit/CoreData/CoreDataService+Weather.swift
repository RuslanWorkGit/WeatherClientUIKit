//
//  CoreDataService+Weather.swift
//  WeatherClientUIKit
//
//  Created by Ruslan Liulka on 25.02.2025.
//

import Foundation
import CoreData

extension CoreDataService {
    
    func createWeathreResult(with weather: WeatherResult) -> CDWeather {
        
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
        
        
        do {
            try context.save()
        } catch {
            print("Error to save: \(error)")
        }
        
        return weatherObject
        
    }
    
}
