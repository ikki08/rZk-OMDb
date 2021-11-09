//
//  ShimmerCell.swift
//  rZk-OMDb
//
//  Created by Rizki on 09/11/21.
//  Copyright © 2021 Rizki Dwi Putra. All rights reserved.
//

import UIKit

class ShimmerCell: UITableViewCell {
    @IBOutlet weak var posterDummyView: UIView!
    @IBOutlet weak var titleDummyView: UIView!
    @IBOutlet weak var yearDummyView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        posterDummyView.startShimmerAnimation()
        titleDummyView.startShimmerAnimation()
        yearDummyView.startShimmerAnimation()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
