//
//  MultipleAppCell.swift
//  LikeAppStore
//
//  Created by ivica petrsoric on 14/06/2019.
//  Copyright © 2019 ivica petrsoric. All rights reserved.
//

import UIKit

class MultipleAppCell: UICollectionViewCell {
    
    var app: FeedResult! {
        didSet {
            nameLabel.text = app.name
            companyLabel.text = app.artistName
            
            imageView.sd_setImage(with: URL(string: app.artworkUrl100))
        }
    }
    
    private let imageView = UIImageView(cornerRadius: 8)
    
    private let nameLabel = UILabel(text: "App name", font: .systemFont(ofSize: 16))
    private let companyLabel = UILabel(text: "Company name", font: .systemFont(ofSize: 13))
    
    private let getButton = UIButton(title: "GET")
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.backgroundColor = .purple
        
        imageView.constrainWidth(constant: 64)
        imageView.constrainHeight(constant: 64)
        
        getButton.backgroundColor = UIColor(white: 0.95, alpha: 1)
        getButton.constrainWidth(constant: 80)
        getButton.constrainHeight(constant: 32)
        getButton.layer.cornerRadius = 16
        getButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            VerticalStackView(arrangedSubviews: [nameLabel, companyLabel], spacing: 4),
            getButton
            ])
        stackView.spacing = 16
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.fillSuperview()
        
        addSubview(separatorView)
        separatorView.anchor(top: nil, leading: nameLabel.leadingAnchor,
                             bottom: bottomAnchor, trailing: trailingAnchor,
                             padding: .init(top: 0, left: 0, bottom: -8, right: 0),
                             size: .init(width: 0, height: 0.5))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
