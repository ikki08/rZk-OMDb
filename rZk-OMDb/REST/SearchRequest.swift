//
//  SearchRequest.swift
//  rZk-OMDb
//
//  Created by Rizki on 08/11/21.
//  Copyright © 2021 Rizki Dwi Putra. All rights reserved.
//

import UIKit
import Alamofire

class SearchRequest: APIRequest {
    let term: String
    
    init(term: String) {
        self.term = term
    }
    
    func endpoint() -> String {
        return "?s=\(term)&apikey=\(API_KEY)"
    }
    
    func method() -> HTTPMethod {
        return .get
    }
}
