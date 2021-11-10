//
//  DashboardVMTests.swift
//  rZk-OMDbTests
//
//  Created by Rizki on 10/11/21.
//  Copyright © 2021 Rizki Dwi Putra. All rights reserved.
//

import XCTest

class DashboardVMTests: XCTestCase {
    var dashboardVM: DashboardViewModel!
    var searchServiceMockUp: MockSearchService!
    var dashboardVMDelegateMockUp: MockDashboardVMDelegate!

    override func setUp() {
        let dummyVideoDataList = createDummyVideoDataList()
        searchServiceMockUp = MockSearchService(dummyVideoDataList: dummyVideoDataList)
        dashboardVMDelegateMockUp = MockDashboardVMDelegate()
        dashboardVM = DashboardViewModel(service: searchServiceMockUp, isFirstAttemp: false)
        dashboardVM.delegate = dashboardVMDelegateMockUp
    }

    override func tearDown() {
        dashboardVM = nil
        searchServiceMockUp = nil
        dashboardVMDelegateMockUp = nil
    }
    
    func testSearchVideoSucceedFirst() {
        dashboardVM.searchVideo(term: "star", forceFromRemote: true)
        XCTAssert(dashboardVMDelegateMockUp.isSearchSucceed)
        XCTAssert(dashboardVM.videoList.count == 3)
    }
    
    func testSearchVideoSucceedSecond() {
        dashboardVM.searchVideo(term: "war", forceFromRemote: true)
        XCTAssert(dashboardVMDelegateMockUp.isSearchSucceed)
        XCTAssert(dashboardVM.videoList.count == 1)
    }
    
    func testSearchVideoFail() {
        dashboardVM.searchVideo(term: "test", forceFromRemote: true)
        XCTAssert(dashboardVMDelegateMockUp.isSearchFail)
        XCTAssert(dashboardVM.videoList.count == 0)
    }
    
    func testClearVideoList() {
        dashboardVM.searchVideo(term: "wars", forceFromRemote: true)
        XCTAssert(dashboardVMDelegateMockUp.isSearchSucceed)
        XCTAssert(dashboardVM.videoList.count == 3)
        
        dashboardVM.clearVideoList()
        XCTAssert(dashboardVM.videoList.count == 0)
    }
}

extension DashboardVMTests {
    private func createDummyVideoDataList() -> Array<Video> {
        let videoDataA = Video(imdbId: "1", title: "Star Wars", year: "1989", type: .movie, posterURL: "N/A")
        let videoDataB = Video(imdbId: "2", title: "Star Wars II", year: "1991", type: .movie, posterURL: "N/A")
        let videoDataC = Video(imdbId: "3", title: "Star Wars III", year: "1994", type: .movie, posterURL: "N/A")
        let videoDataD = Video(imdbId: "4", title: "World War Z", year: "2012", type: .movie, posterURL: "N/A")
        
        return [videoDataA, videoDataB, videoDataC, videoDataD]
    }
}

class MockSearchService: SearchServiceProtocol {
    var dummyVideoDataList: Array<Video>
    
    init(dummyVideoDataList: Array<Video>) {
        self.dummyVideoDataList = dummyVideoDataList
    }
    
    func searchVideo(term: String, forceFromRemote: Bool, cache: NSCache<NSString, AnyObject>, success: @escaping ([Video], Bool) -> Void, failure: @escaping (Error) -> Void) {
        var videoList = Array<Video>()
        let lowercasedTerm = term.lowercased()
        for videoData in dummyVideoDataList {
            let title = videoData.title.lowercased()
            if isContains(word: lowercasedTerm, in: title) {
                videoList.append(videoData)
            }
        }
        
        if videoList.count > 0 {
            success(videoList, false)
        } else {
            let error = NSError(domain: "",
                                code: StatusCode.errorGeneral,
                                userInfo: ["description": "Something went wrong!"])
            failure(error)
        }
    }
    
    private func isContains(word: String, in text: String) -> Bool {
        return text.range(of: "\\b\(word)\\b", options: .regularExpression) != nil
    }
}

class MockDashboardVMDelegate: NSObject, DashboardVMDelegate {
    var isSearchSucceed = false
    var isSearchFail = false
    
    func searchDidSucceed() {
        isSearchSucceed = true
    }
    
    func searchDidFail(with message: String) {
        isSearchFail = true
    }
}
