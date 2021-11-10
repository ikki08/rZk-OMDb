//
//  SearchService.swift
//  rZk-OMDb
//
//  Created by Rizki on 08/11/21.
//  Copyright © 2021 Rizki Dwi Putra. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol SearchServiceProtocol {
    func searchVideo(term: String, forceFromRemote: Bool, cache: NSCache<NSString, AnyObject>, success: @escaping ([Video], Bool) -> Void, failure: @escaping (Error) -> Void)
}

class SearchService: SearchServiceProtocol {
    func searchVideo(term: String, forceFromRemote: Bool = false, cache: NSCache<NSString, AnyObject>, success: @escaping ([Video], Bool) -> Void, failure: @escaping (Error) -> Void) {
        let lowercasedTerm = term.lowercased()
        let apiClient = APIClient()
        apiClient.cancelAllRequest() { [weak self] in
            guard let `self` = self else { return }
            
            if !forceFromRemote, let cachedResponse = cache.object(forKey: lowercasedTerm as NSString) {
                let jsonResponse = JSON(cachedResponse)
                let result = self.handleResponse(jsonResponse)
                if let videoList = result.0 {
                    success(videoList, true)
                } else if let error = result.1 {
                    failure(error)
                }
            } else {
                let searchRequest = SearchRequest(term: lowercasedTerm)
                apiClient.execute(request: searchRequest,
                                  success: { [weak self] response in
                                    guard let `self` = self else { return }
                                    
                                    let jsonResponse = JSON(response)
                                    cache.setObject(response as AnyObject, forKey: lowercasedTerm as NSString)
                                    let result = self.handleResponse(jsonResponse)
                                    if let videoList = result.0 {
                                        success(videoList, false)
                                    } else if let error = result.1 {
                                        failure(error)
                                    }
                },
                                  failure: { error in
                                    failure(error)
                })
            }
        }
    }
    
    private func handleResponse(_ response: JSON) -> (Array<Video>?, Error?) {
        if let reqResponse = response["Response"].string,
            reqResponse == "True" {
            let videoList = parseVideoDataJSON(response)
            return (videoList, nil)
        } else {
            let errorMessage = response["Error"].string!
            let error = NSError(domain: "",
                                code: StatusCode.errorTooManyResult,
                                userInfo: ["description": errorMessage])
            return (nil, error)
        }
    }
    
    private func parseVideoDataJSON(_ videoDataJSON: JSON) -> Array<Video> {
        var videoList = Array<Video>()
        let jsonArray = videoDataJSON["Search"].array!
        for jsonData in jsonArray {
            let video = Video(json: jsonData)
            videoList.append(video)
        }
        
        return videoList
    }
}
