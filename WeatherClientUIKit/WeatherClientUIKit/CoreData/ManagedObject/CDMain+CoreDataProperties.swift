//
//  CDMain+CoreDataProperties.swift
//  WeatherClientUIKit
//
//  Created by Ruslan Liulka on 25.02.2025.
//
//

import Foundation
import CoreData


extension CDMain {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMain> {
        return NSFetchRequest<CDMain>(entityName: "CDMain")
    }

    @NSManaged public var humidity: Int64
    @NSManaged public var id: Int64
    @NSManaged public var preasure: Int64
    @NSManaged public var temp: Double
    @NSManaged public var weather: CDWeather?

}

extension CDMain : Identifiable {

}
