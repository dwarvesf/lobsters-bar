//
//  Post.swift
//  Lobsters Bar
//
//  Created by Phuc Le Dien on 1/24/19.
//  Copyright © 2019 phucledien. All rights reserved.
//

import ObjectMapper

struct Post {
    var title: String = ""
    var points: Int = 0
    var comments: Int = 0
    var datePublished: Date = Date()
    var url: String = ""
}

extension Post: Mappable {
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        self.title          <- map["title"]
        self.url            <- map["url"]
        self.points         <- map["vote_number"]
        self.comments       <- map["comments"]
        self.datePublished  <- (map["date_published"], DateStringTransform())
    }
}


class DateStringTransform: TransformType {
    typealias Object = Date
    
    typealias JSON = String
    
    func transformFromJSON(_ value: Any?) -> Object? {
        var date = Date()
        if let dateStr = value as? String {
            let dateFormatter = ISO8601DateFormatter()
            date = dateFormatter.date(from: dateStr)!
        }
        
        return date
    }
    
    func transformToJSON(_ value: Object?) -> JSON? {
        var dateStr = ""
        if let date = value {
            let dateFormatter = ISO8601DateFormatter()
            dateStr = dateFormatter.string(from: date)
        }
        return dateStr
    }
}
