//
//  Const.swift
//  Lobsters Bar
//
//  Created by Phuc Le Dien on 1/30/19.
//  Copyright © 2019 phucledien. All rights reserved.
//

import Foundation

extension UserDefaults {
    enum Name {
        static let isAutoStart = "isAutoStart"
        static let timeToRefresh = "timeToRefresh"
    }
}

extension NotificationCenter {
    enum Name {
         static let settingDidChanged = "settingDidChanged"
    }
}
