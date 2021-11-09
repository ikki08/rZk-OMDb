//
//  DashboardViewModel.swift
//  rZk-OMDb
//
//  Created by Rizki on 08/11/21.
//  Copyright © 2021 Rizki Dwi Putra. All rights reserved.
//

import UIKit

protocol DashboardVMDelegate: NSObjectProtocol {
    func searchDidSucceed()
    func searchDidFail(with message: String)
}

class DashboardViewModel {
    weak var delegate: DashboardVMDelegate?
    private let searchService: SearchServiceProtocol
    private(set) var videoList: Array<Video>
    let imageCache = NSCache<NSString, UIImage>()
    let responseCache = NSCache<NSString, AnyObject>()
    var isRequestingToServer = false
    
    init(service: SearchServiceProtocol) {
        self.searchService = service
        self.videoList = Array()
    }
    
    func searchVideo(term: String) {
        self.videoList.removeAll()
        searchService.searchVideo(term: term,
                                  cache: responseCache,
                                  success: { [weak self] videos in
            guard let `self` = self else { return }
            
            self.videoList.append(contentsOf: videos)
            self.delegate?.searchDidSucceed()
        }, failure: { [weak self] error in
            guard let `self` = self else { return }
            
            if let anError = error as NSError?,
                let message = anError.userInfo["description"] as! String? {
                self.delegate?.searchDidFail(with: message)
            } else {
                self.delegate?.searchDidFail(with: "Something went wrong!")
            }
        })
    }
    
    func clearVideoList() {
        self.videoList.removeAll()
    }
}
