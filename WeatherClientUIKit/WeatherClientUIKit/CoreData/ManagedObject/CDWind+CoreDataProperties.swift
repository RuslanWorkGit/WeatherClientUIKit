//
//  CDWind+CoreDataProperties.swift
//  WeatherClientUIKit
//
//  Created by Ruslan Liulka on 25.02.2025.
//
//

import Foundation
import CoreData


extension CDWind {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDWind> {
        return NSFetchRequest<CDWind>(entityName: "CDWind")
    }

    @NSManaged public var deg: Int64
    @NSManaged public var id: Int64
    @NSManaged public var weather: CDWeather?

}

extension CDWind : Identifiable {

}
