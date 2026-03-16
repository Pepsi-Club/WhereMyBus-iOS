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
public class FavoritesBusResponseMO: NSManagedObject, CoreDataModelObject, DTOParsable {
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

extension FavoritesBusResponse: CoreDataRepresentable {
    private func requiredValue<T>(_ value: T?, forKey key: String) throws -> T {
        guard let value = value else {
            throw CocoaError(.validationMissingMandatoryProperty, userInfo: [NSValidationKeyErrorKey: key])
        }
        return value
    }

    public var id: String { identifier }
    
    public init(_ managedObject: FavoritesBusResponseMO) throws {
        let busStopId = try managedObject.unwrap(\.busStopId)
        let busStopName = try managedObject.unwrap(\.busStopName)
        let busId = try managedObject.unwrap(\.busId)
        let busName = try managedObject.unwrap(\.busName)
        let adirection = try managedObject.unwrap(\.adirection)
        self.init(
            busStopId: busStopId,
            busStopName: busStopName,
            busId: busId,
            busName: busName,
            adirection: adirection
        )
    }
    
    public func apply(to managedObject: FavoritesBusResponseMO) {
        managedObject.identifier = identifier
        managedObject.busStopId = busStopId
        managedObject.busStopName = busStopName
        managedObject.busId = busId
        managedObject.busName = busName
        managedObject.adirection = adirection
    }
}
