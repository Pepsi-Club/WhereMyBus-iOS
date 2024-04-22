//
//  FavoritesBusResponseMO+CoreDataProperties.swift
//  
//
//  Created by gnksbm on 4/16/24.
//
//

import Foundation
import CoreData

extension FavoritesBusResponseMO {
    @nonobjc public class func fetchRequest(
    ) -> NSFetchRequest<FavoritesBusResponseMO> {
        return NSFetchRequest<FavoritesBusResponseMO>(
            entityName: "FavoritesBusResponseMO"
        )
    }

    @NSManaged public var identifier: String?
    @NSManaged public var busStopId: String?
    @NSManaged public var busStopName: String?
    @NSManaged public var busId: String?
    @NSManaged public var busName: String?
    @NSManaged public var adirection: String?
}
