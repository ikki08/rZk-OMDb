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
    func searchDidFail()
}

class DashboardViewModel {
    weak var delegate: DashboardVMDelegate?
    private let searchService: SearchServiceProtocol
    private(set) var videoList: Array<Video>
    
    init(service: SearchServiceProtocol) {
        self.searchService = service
        self.videoList = Array()
    }
    
    func searchVideo(term: String) {
        searchService.searchVideo(term: term,
                                  success: { [weak self] videos in
            guard let `self` = self else { return }
            self.videoList.removeAll()
            self.videoList.append(contentsOf: videos)
            self.delegate?.searchDidSucceed()
        }, failure: { [weak self] error in
            guard let `self` = self else { return }
            self.delegate?.searchDidFail()
        })
    }
}
