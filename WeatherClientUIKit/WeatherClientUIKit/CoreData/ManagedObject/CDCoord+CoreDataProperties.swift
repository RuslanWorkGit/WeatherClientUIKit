//
//  CDCoord+CoreDataProperties.swift
//  WeatherClientUIKit
//
//  Created by Ruslan Liulka on 25.02.2025.
//
//

import Foundation
import CoreData


extension CDCoord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCoord> {
        return NSFetchRequest<CDCoord>(entityName: "CDCoord")
    }

    @NSManaged public var id: Int64
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var weather: CDWeather?

}

extension CDCoord : Identifiable {

}
