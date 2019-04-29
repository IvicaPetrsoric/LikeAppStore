//
//  PreviewCell.swift
//  LikeAppStore
//
//  Created by ivica petrsoric on 29/04/2019.
//  Copyright © 2019 ivica petrsoric. All rights reserved.
//

import UIKit

class PreviewCell: UICollectionViewCell {
    
    let previewLabel = UILabel(text: "Preview", font: .boldSystemFont(ofSize: 20))
    let horizontalController = PreviewScreenshotsController()
    let borderView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(borderView)
        addSubview(previewLabel)
        addSubview(horizontalController.view)
        
        borderView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        borderView.constrainHeight(constant: 1)
        borderView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        previewLabel.anchor(top: topAnchor, leading: leadingAnchor,
                            bottom: nil, trailing: trailingAnchor,
                            padding: .init(top: 4, left: 20, bottom: 0, right: 20))
        
        horizontalController.view.anchor(top: previewLabel.bottomAnchor, leading: leadingAnchor,
                                         bottom: bottomAnchor, trailing: trailingAnchor,
                                         padding: .init(top: 16, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
