//
//  NetworkAdapter.swift
//  Lobsters Bar
//
//  Created by Phuc Le Dien on 1/24/19.
//  Copyright © 2019 phucledien. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper
import Alamofire
import RxAlamofire

class NetworkAdapter {
    enum Header {
        static let noneAuthenticateHeader = [
            "Content-Type": "application/json; charset=utf-8"
        ]
    }
}

//MARK:
extension NetworkAdapter {
    class func getFrontpage() -> Observable<[Post]> {
        let url = "https://lobster.kalimtab.com/api/lobsters"
        return APIEngine.queryArrayData(method: .get, url: url, parameters: nil, header: nil)
    }
}
