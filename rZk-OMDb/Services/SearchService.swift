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
    func searchVideo(term: String, cache: NSCache<NSString, AnyObject>, success: @escaping ([Video]) -> Void, failure: @escaping (Error) -> Void)
}

class SearchService: SearchServiceProtocol {
    func searchVideo(term: String, cache: NSCache<NSString, AnyObject>, success: @escaping ([Video]) -> Void, failure: @escaping (Error) -> Void) {
         let lowercasedTerm = term.lowercased()

        if let cachedResponse = cache.object(forKey: lowercasedTerm as NSString) {
            let jsonResponse = JSON(cachedResponse)
            let videoList = self.parseResponse(jsonResponse)
            
            success(videoList)
        } else {
            let searchRequest = SearchRequest(term: lowercasedTerm)
            
            let apiClient = APIClient()
            apiClient.execute(request: searchRequest,
                              success: { [weak self] response in
                                guard let `self` = self else { return }
                                
                                let jsonResponse = JSON(response)
                                cache.setObject(response as AnyObject, forKey: lowercasedTerm as NSString)
                                
                                let videoList = self.parseResponse(jsonResponse)
                                
                                success(videoList)
            },
                              failure: { error in
                                failure(error)
            })
        }
    }
    
    private func parseResponse(_ response: JSON) -> Array<Video> {
        var videoList = Array<Video>()
        let jsonArray = response["Search"].array!
        for jsonData in jsonArray {
            let video = Video(json: jsonData)
            videoList.append(video)
        }
        
        return videoList
    }
}
