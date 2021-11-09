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
    func setImage(urlString: String, cache: NSCache<NSString, UIImage>, completion: @escaping () -> Void) {
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            completion()
        } else {
            self.sd_setImage(with: URL(string: urlString),
                             completed: { (image, _, _, _) -> Void in
                                guard let posterImage = image else { return }
                                cache.setObject(posterImage, forKey: urlString as NSString)
                                completion()
            })
        }
    }
}
