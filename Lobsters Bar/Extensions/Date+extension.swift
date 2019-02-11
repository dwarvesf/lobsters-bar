//
//  Date+extension.swift
//  Lobsters Bar
//
//  Created by Phuc Le Dien on 2/11/19.
//  Copyright © 2019 phucledien. All rights reserved.
//

import Foundation

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        if secondsAgo < minute {
            return "Updated \(secondsAgo) seconds ago"
        }
            
        else if secondsAgo < hour {
            return "Updated \(secondsAgo / minute) minutes ago"
        }
        else if secondsAgo < day {
            return "Updated \(secondsAgo / hour) hours ago"
        }
        else if secondsAgo < week {
            return "Updated \(secondsAgo / day) days ago"
        }
        return "Updated \(secondsAgo / week) weeks ago"
    }
}
