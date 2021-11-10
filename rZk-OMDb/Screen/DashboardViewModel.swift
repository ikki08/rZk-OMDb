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
    var isFirstAttemp = false
    var shouldReqAgainFromRemote = false
    
    init(service: SearchServiceProtocol, isFirstAttemp: Bool) {
        self.searchService = service
        self.videoList = Array()
        self.isFirstAttemp = isFirstAttemp
    }
    
    func searchVideo(term: String, forceFromRemote: Bool) {
        self.videoList.removeAll()
        searchService.searchVideo(term: term,
                                  forceFromRemote: forceFromRemote,
                                  cache: responseCache,
                                  success: { [weak self] videos, isFromCache in
            guard let `self` = self else { return }
            
            if isFromCache, self.isFirstAttemp {
                self.shouldReqAgainFromRemote = true
            } else {
                self.shouldReqAgainFromRemote = false
            }
            
            self.isFirstAttemp = false
            self.videoList.append(contentsOf: videos)
            self.delegate?.searchDidSucceed()
        }, failure: { [weak self] error in
            guard let `self` = self else { return }
            
            self.shouldReqAgainFromRemote = false
            self.isFirstAttemp = false
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
