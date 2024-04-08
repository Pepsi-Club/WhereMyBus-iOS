//
//  String+.swift
//  Core
//
//  Created by gnksbm on 2023/12/27.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import UIKit
import CoreLocation

public extension String {
    func toDate(dateFormat: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = .current
        guard let date = dateFormatter.date(from: self)
        else {
            fatalError("Invalid String to dateFormat")
        }
        return date
    }
    
    static var serverKey: Self {
        guard let any = Bundle.main.object(
            forInfoDictionaryKey: "DATA_GO_KR_API_KEY"
        ),
              let serverKey = any as? String
        else { fatalError("Can't Not Find Server Key") }
        return serverKey
    }
    
    static var fcmKey: Self {
        guard let any = Bundle.main.object(forInfoDictionaryKey: "FCM_KEY"),
              let serverKey = any as? String
        else { fatalError("Can't Not Find FCM Key") }
        return serverKey
    }
    
    static func getCurrentVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String
        else { return "" }
        
        return version
    }
    
    static func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier
        = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8,
                  value != 0
            else { return identifier }
            
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        print("🆕 : \(identifier)")
        return identifier
    }
}
