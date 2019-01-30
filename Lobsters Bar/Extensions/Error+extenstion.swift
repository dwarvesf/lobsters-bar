//
//  Error+extenstion.swift
//  Lobsters Bar
//
//  Created by Phuc Le Dien on 1/24/19.
//  Copyright © 2019 phucledien. All rights reserved.
//

import Foundation
enum NetworkError:Error {
    case Error(message:String)
}
extension Error {
    func description() -> String {
        if let error = self as? NetworkError {
            switch error {
            case .Error(message: let message):
                return message
            }
        } else {
            return self.localizedDescription
        }
    }
}
