//
//  FavoritesBusResponseMO+CoreDataClass.swift
//  
//
//  Created by gnksbm on 4/16/24.
//
//

import Foundation
import CoreData

import Core
import Domain

@objc(FavoritesBusResponseMO)
public class FavoritesBusResponseMO: NSManagedObject, CoreDataModelObject {
    public var toDomain: CoreDataStorable {
        guard let busStopId,
              let busStopName,
              let busId,
              let busName,
              let adirection
        else { fatalError() }
        return FavoritesBusResponse(
            busStopId: busStopId,
            busStopName: busStopName,
            busId: busId,
            busName: busName,
            adirection: adirection
        )
    }
}
