//
//  ForceUpdate.swift
//  Domain
//
//  Created by Jisoo Ham on 3/27/25.
//  Copyright © 2025 Pepsi-Club. All rights reserved.
//

import Foundation

public enum ForceUpdate {
    case notNeeded
    case needed(appStoreURL: URL)
}
