//
//  TrackCell.swift
//  LikeAppStore
//
//  Created by ivica petrsoric on 15/06/2019.
//  Copyright © 2019 ivica petrsoric. All rights reserved.
//

import UIKit

class TrackCell: UICollectionViewCell {
    
    let imageView = UIImageView(cornerRadius: 16)
    let nameLabel = UILabel(text: "Track Name", font: .boldSystemFont(ofSize: 18))
    let substitleLabel = UILabel(text: "Substitle Label", font: .systemFont(ofSize: 16), numberOfLines: 2)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.image = #imageLiteral(resourceName: "garden")
        imageView.constrainWidth(constant: 80)
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView, VerticalStackView(arrangedSubviews: [
                nameLabel, substitleLabel
                ], spacing: 4)
            ], customSpacing: 16)
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        stackView.alignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
