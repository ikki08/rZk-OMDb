//
//  UIImageView+SetImage.swift
//  rZk-OMDb
//
//  Created by Rizki on 09/11/21.
//  Copyright © 2021 Rizki Dwi Putra. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    func setImage(urlString: String, completion: @escaping () -> Void) {
        let imageCache = NSCache<NSString, UIImage>()
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            completion()
            self.image = cachedImage
        } else {
            self.sd_setImage(with: URL(string: urlString),
                             completed: { (image, _, _, _) -> Void in
                                completion()
                                guard let posterImage = image else { return }
                                imageCache.setObject(posterImage, forKey: urlString as NSString)
            })
        }
    }
}
