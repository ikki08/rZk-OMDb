//
//  APIRequest.swift
//  rZk-OMDb
//
//  Created by Rizki on 08/11/21.
//  Copyright © 2021 Rizki Dwi Putra. All rights reserved.
//

import UIKit
import Alamofire

let API_KEY = "434d2575"
let BASE_URL = "https://www.omdbapi.com/"

protocol APIRequest {
    func parameters() -> [String: Any]?
    func endpoint() -> String
    func method() -> HTTPMethod
}

extension APIRequest {
    func url() -> URL? {
        return URL(string: urlString())
    }
    
    func urlString() -> String {
        return BASE_URL + endpoint()
    }
    
    func headers() -> [String: String] {        
        return ["Content-Type": "application/json"]
    }
    
    func parameters() -> [String: Any]? {
        return nil
    }
}

