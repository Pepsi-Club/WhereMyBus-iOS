//
//  EntityRepresentable.swift
//  Domain
//
//  Created by gnksbm on 2/23/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation
import CoreData

public protocol EntityRepresentable: NSManagedObject {
    var toEntity: Storable { get }
}
