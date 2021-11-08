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
    func searchVideo(term: String, success: @escaping ([Video]) -> Void, failure: @escaping (Error) -> Void)
}

class SearchService: SearchServiceProtocol {
    func searchVideo(term: String, success: @escaping ([Video]) -> Void, failure: @escaping (Error) -> Void) {
        let searchRequest = SearchRequest(term: term)
        
        let apiClient = APIClient()
        apiClient.execute(request: searchRequest,
                          success: { response in
                            let jsonResponse = JSON(response)
                            var videoList = Array<Video>()
                            let jsonArray = jsonResponse["Search"].array!
                            for jsonData in jsonArray {
                                let video = Video(json: jsonData)
                                videoList.append(video)
                            }
                            
                            success(videoList)
        },
                          failure: { error in
                            failure(error)
        })
    }
}
