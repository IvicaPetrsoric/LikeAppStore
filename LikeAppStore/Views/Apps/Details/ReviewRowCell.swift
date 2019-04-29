//
//  ReviewRowCell.swift
//  LikeAppStore
//
//  Created by ivica petrsoric on 29/04/2019.
//  Copyright © 2019 ivica petrsoric. All rights reserved.
//

import UIKit

class ReviewRowCell: UICollectionViewCell {
    
    let reviewController = ReviewsController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(reviewController.view)
        reviewController.view.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
