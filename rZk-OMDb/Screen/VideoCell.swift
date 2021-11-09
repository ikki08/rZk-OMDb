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
    @IBOutlet weak var notAvailableLabel: UILabel!
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
    
    func setup(with video: Video) {
        if video.posterUrl != "" {
            posterImageView.setImage(urlString: video.posterUrl) { [weak self] in
                guard let `self` = self else { return }
                self.notAvailableLabel.isHidden = true
            }
        } else {
            self.notAvailableLabel.isHidden = false
        }
        
        titleLabel.text = video.title
        yearLabel.text = video.year
    }
}
