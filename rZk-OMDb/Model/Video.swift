//
//  Video.swift
//  rZk-OMDb
//
//  Created by Rizki on 08/11/21.
//  Copyright © 2021 Rizki Dwi Putra. All rights reserved.
//

import UIKit
import SwiftyJSON

enum VideoType: String {
    case movie = "movie"
    case series = "series"
    case unknown = "unknown"
}

class Video: NSObject {
    let imdbId: String
    let title: String
    let year: String
    let type: VideoType
    let posterUrl: String
    
    init(json: JSON) {
        self.imdbId = json["imdbID"].string!
        self.title = json["Title"].string!
        self.year = json["Year"].string!
        self.type = VideoType(rawValue: json["Type"].string!) ?? .unknown
        let urlString = json["Poster"].string!
        if urlString != "N/A" {
            self.posterUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
        } else {
            self.posterUrl = ""
        }
    }
    
    init(imdbId: String, title: String, year: String, type: VideoType, posterURL: String) {
        self.imdbId = imdbId
        self.title = title
        self.year = year
        self.type = type
        self.posterUrl = posterURL
    }
}
