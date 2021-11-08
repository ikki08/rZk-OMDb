//
//  APIClient.swift
//  rZk-OMDb
//
//  Created by Rizki on 08/11/21.
//  Copyright © 2021 Rizki Dwi Putra. All rights reserved.
//

import UIKit
import Alamofire

struct StatusCode {
    static let accepted: Int = 202
    static let errorGeneral: Int = 4000
    static let unauthorized: Int = 401
    static let errorConflict: Int = 409
}

class APIClient: NSObject {
    func execute(request: APIRequest, success: @escaping (Any) -> Void, failure: @escaping (Error) -> Void) {
        let dataRequest = Alamofire.request(request.urlString(),
                                            method: request.method(),
                                            parameters: request.parameters(),
                                            encoding: JSONEncoding.default,
                                            headers: request.headers())
        
        dataRequest.responseJSON() { response in
            switch response.result {
            case .success(let value):
                success(value)
                break
                
            case .failure(let error):
                failure(error)
                break
            }
        }
    }
}

