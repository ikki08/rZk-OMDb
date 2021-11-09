//
//  VideoCell.swift
//  rZk-OMDb
//
//  Created by Rizki on 09/11/21.
//  Copyright © 2021 Rizki Dwi Putra. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var posterStatusLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(with video: Video, cache: NSCache<NSString, UIImage>) {
        posterImageView.image = nil
        posterStatusLabel.isHidden = false
        if video.posterUrl != "" {
            posterStatusLabel.text = "⟳" // text when still fetching the image
            posterImageView.setImage(urlString: video.posterUrl, cache: cache) { [weak self] in
                guard let `self` = self else { return }
                self.posterStatusLabel.isHidden = true
            }
        } else {
            posterStatusLabel.text = "N/A"
        }
        
        titleLabel.text = video.title
        yearLabel.text = video.year
    }
}
