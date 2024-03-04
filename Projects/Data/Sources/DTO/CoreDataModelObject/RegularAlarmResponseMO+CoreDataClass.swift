//
//  RegularAlarmResponseMO+CoreDataClass.swift
//  
//
//  Created by gnksbm on 2/25/24.
//
//

import Foundation
import CoreData

import Core
import Domain

@objc(RegularAlarmResponseMO)
public class RegularAlarmResponseMO: NSManagedObject, CoreDataModelObject {
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
