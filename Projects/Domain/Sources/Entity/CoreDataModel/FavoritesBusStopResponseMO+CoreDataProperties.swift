//
//  FavoritesBusStopResponseMO+CoreDataProperties.swift
//  
//
//  Created by gnksbm on 2/25/24.
//
//

import Foundation
import CoreData

import Core

extension FavoritesBusStopResponseMO: CoreDataModelObject {
    @nonobjc public class func fetchRequest(
    ) -> NSFetchRequest<FavoritesBusStopResponseMO> {
        return NSFetchRequest<FavoritesBusStopResponseMO>(
            entityName: "FavoritesBusStopMO"
        )
    }
    
    @NSManaged public var busStopId: String?
    @NSManaged public var busIds: [String]?
    
    public var toDomain: CoreDataStorable {
        guard let busIds,
              let busStopId
        else { fatalError() }
        return FavoritesBusStopResponse(
            busStopId: busStopId,
            busIds: busIds
        )
    }
}
