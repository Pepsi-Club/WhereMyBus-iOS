//
//  CoreDataRepresentable.swift
//  CoreDataService
//
//  Created by Logan on 6/21/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import CoreData

public protocol CoreDataRepresentable: Identifiable where ID: CVarArg {
    associatedtype ManagedObject: NSManagedObject
    
    init(_ managedObject: ManagedObject) throws
    
    func apply(to managedObject: ManagedObject)
}
