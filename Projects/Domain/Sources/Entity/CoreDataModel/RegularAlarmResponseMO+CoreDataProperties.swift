//
//  RegularAlarmResponseMO+CoreDataProperties.swift
//  
//
//  Created by gnksbm on 2/25/24.
//
//

import Foundation
import CoreData

import Core

extension RegularAlarmResponseMO: CoreDataModelObject {
    @nonobjc public class func fetchRequest(
    ) -> NSFetchRequest<RegularAlarmResponseMO> {
        return NSFetchRequest<RegularAlarmResponseMO>(
            entityName: "RegularAlarmResponseMO"
        )
    }

    @NSManaged public var weekDay: [Int16]?
    @NSManaged public var time: Date?
    @NSManaged public var busStopName: String?
    @NSManaged public var busStopId: String?
    @NSManaged public var busName: String?
    @NSManaged public var busId: String?
    
    public var toDomain: CoreDataStorable {
        guard let busStopId,
              let busStopName,
              let busId,
              let busName,
              let time,
              let weekDay
        else { fatalError() }
        return RegularAlarmResponse(
            busStopId: busStopId,
            busStopName: busStopName,
            busId: busId,
            busName: busName,
            time: time,
            weekDay: weekDay.map { Int($0) }
        )
    }
}
