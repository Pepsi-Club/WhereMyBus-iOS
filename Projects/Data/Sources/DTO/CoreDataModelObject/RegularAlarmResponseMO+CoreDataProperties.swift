//
//  RegularAlarmResponseMO+CoreDataProperties.swift
//  
//
//  Created by gnksbm on 4/6/24.
//
//

import Foundation
import CoreData

extension RegularAlarmResponseMO {
    @nonobjc public class func fetchRequest(
    ) -> NSFetchRequest<RegularAlarmResponseMO> {
        return NSFetchRequest<RegularAlarmResponseMO>(
            entityName: "RegularAlarmResponseMO"
        )
    }

    @NSManaged public var requestId: String?
    @NSManaged public var busStopId: String?
    @NSManaged public var busStopName: String?
    @NSManaged public var busId: String?
    @NSManaged public var busName: String?
    @NSManaged public var time: Date?
    @NSManaged public var weekday: [Int]?
}
