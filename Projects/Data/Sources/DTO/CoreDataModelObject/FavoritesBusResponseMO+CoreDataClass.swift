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
import CoreDataService

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

extension FavoritesBusResponse: CoreDataModel {
    public var id: String { identifier }
    
    public static func toDataModel(_ object: FavoritesBusResponseMO) -> FavoritesBusResponse {
        guard let busStopId = object.busStopId,
              let busStopName = object.busStopName,
              let busId = object.busId,
              let busName = object.busName,
              let adirection = object.adirection
        else { fatalError() }
        return FavoritesBusResponse(
            busStopId: busStopId,
            busStopName: busStopName,
            busId: busId,
            busName: busName,
            adirection: adirection
        )
    }
    
    public func sync(for managedObject: FavoritesBusResponseMO) {
        managedObject.identifier = identifier
        managedObject.busStopId = busStopId
        managedObject.busStopName = busStopName
        managedObject.busId = busId
        managedObject.busName = busName
        managedObject.adirection = adirection
    }
}
