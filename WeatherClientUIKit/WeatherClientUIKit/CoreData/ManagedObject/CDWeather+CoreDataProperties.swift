//
//  CDWeather+CoreDataProperties.swift
//  WeatherClientUIKit
//
//  Created by Ruslan Liulka on 25.02.2025.
//
//

import Foundation
import CoreData


extension CDWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDWeather> {
        return NSFetchRequest<CDWeather>(entityName: "CDWeather")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var coord: CDCoord?
    @NSManaged public var main: CDMain?
    @NSManaged public var wind: CDWind?

}

extension CDWeather : Identifiable {

}
