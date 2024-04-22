//
//  RegularAlarmResponseMO+CoreDataClass.swift
//  
//
//  Created by gnksbm on 4/6/24.
//
//

import Foundation
import CoreData

import Core
import Domain

@objc(RegularAlarmResponseMO)
public class RegularAlarmResponseMO: NSManagedObject, CoreDataModelObject {
    public var toDomain: CoreDataStorable {
        guard let requestId,
              let busStopId,
              let busStopName,
              let busId,
              let busName,
              let time,
              let weekday,
              let adirection
        else { fatalError() }
        return RegularAlarmResponse(
            requestId: requestId,
            busStopId: busStopId,
            busStopName: busStopName,
            busId: busId,
            busName: busName,
            time: time,
            weekday: weekday,
            adirection: adirection
        )
    }
}
