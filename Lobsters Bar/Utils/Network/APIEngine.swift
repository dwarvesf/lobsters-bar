//
//  APIEngine.swift
//  TemplateProject
//
//  Created by TrungPhan on 7/4/18.
//  Copyright © 2018 Dwarvesv. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import RxAlamofire
import RxSwift

class APIEngine {
    static func queryData<T:Mappable>(method: HTTPMethod, url:URLConvertible, parameters: [String:Any]?, header: [String: String]?) -> Observable<T> {
        return RxAlamofire.requestJSON(method, url, parameters: parameters, encoding: JSONEncoding.default, headers: header).map{httpResponse, json in
            let invalidJSON = NetworkError.Error(message: "Invalid Response")
            guard (200..<300).contains(httpResponse.statusCode)
                else {
                    if let json = json as? [String:Any], let message = json["error"] as? String {
                        throw NetworkError.Error(message: message)
                    }
                    throw invalidJSON
            }
            guard let json = json as? [String:Any] else {
                throw invalidJSON
            }
            guard let data = Mapper<T>().map(JSON: json) else {
                throw invalidJSON
            }
            return data
        }
    }
    static func queryArrayData<T:Mappable>(method: HTTPMethod, url:URLConvertible, parameters: [String:Any]?, header: [String: String]?) -> Observable<[T]> {
        return RxAlamofire.requestJSON(method, url, parameters: parameters, encoding: JSONEncoding.default, headers: header).map{httpResponse, json in
            let invalidJSON = NetworkError.Error(message: "Invalid Response")
            guard (200..<300).contains(httpResponse.statusCode)
                else {
                    if let json = json as? [String:Any], let message = json["error"] as? String {
                        throw NetworkError.Error(message: message)
                    }
                    throw invalidJSON
            }
            //=> handle backen may wrape array in key data
            if let json = json as? [String:Any], let data = json["data"], let datas = data as? [[String:Any]] {
                return Mapper<T>().mapArray(JSONArray: datas)
            }else if let data = json as? [[String:Any]]
            {
                return Mapper<T>().mapArray(JSONArray: data)
            }else {
                throw invalidJSON
            }
        }
    }
}
