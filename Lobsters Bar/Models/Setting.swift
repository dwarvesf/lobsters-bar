//
//  Setting.swift
//  Lobsters Bar
//
//  Created by Phuc Le Dien on 1/30/19.
//  Copyright © 2019 phucledien. All rights reserved.
//

import Foundation

class Setting {
    
    static var isAutoStart: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaults.Name.isAutoStart)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Name.isAutoStart)
        }
    }
    
    static var timeToRefresh: Int {
        get {
            let timeToRefresh = UserDefaults.standard.integer(forKey: UserDefaults.Name.timeToRefresh)
            return timeToRefresh != 0 ? timeToRefresh : 10
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Name.timeToRefresh)
        }
    }
}
