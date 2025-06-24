//
//  CoreDataModel.swift
//  CoreDataService
//
//  Created by Logan on 6/21/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import CoreData

public protocol CoreDataModel: Identifiable where ID: CVarArg {
    associatedtype ManagedObject: NSManagedObject
    static func toDataModel(_ object: ManagedObject) -> Self
    
    func sync(for managedObject: ManagedObject)
}
