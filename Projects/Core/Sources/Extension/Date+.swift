//
//  Date+.swift
//  Core
//
//  Created by gnksbm on 2024/01/02.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public extension Date {
    /**
     Date를 String으로 변환
     - Parameters:
        - dateFormat: 변환할 포맷
     - Returns: 포맷된 String 반환
     */
    func toString(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = .current
        return dateFormatter.string(from: self)
    }
}
