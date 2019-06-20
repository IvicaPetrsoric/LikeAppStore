//
//  AppDetailsCell.swift
//  LikeAppStore
//
//  Created by ivica petrsoric on 28/04/2019.
//  Copyright © 2019 ivica petrsoric. All rights reserved.
//

import UIKit

class AppDetailsCell: UICollectionViewCell {
    
    var app: Result! {
        didSet {
            nameLabel.text = app?.trackName
            releaseNotesLabel.text = app?.releaseNotes
            appIconImageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
            priceButton.setTitle(app?.formattedPrice, for: .normal)
        }
    }
    
    private let appIconImageView = UIImageView(cornerRadius: 16)

    private let priceButton = UIButton(title: "$4.99")

    private let nameLabel = UILabel(text: "App name", font: .boldSystemFont(ofSize: 24), numberOfLines: 2)
    private let whatsNewLabel = UILabel(text: "What's new", font: .boldSystemFont(ofSize: 20))
    private let releaseNotesLabel = UILabel(text: "Release notes", font: .systemFont(ofSize: 18), numberOfLines: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        appIconImageView.backgroundColor = .red
        appIconImageView.constrainWidth(constant: 140)
        appIconImageView.constrainHeight(constant: 140)
        
        priceButton.backgroundColor = #colorLiteral(red: 0, green: 0.4655796289, blue: 1, alpha: 1)
        priceButton.constrainHeight(constant: 32)
        priceButton.constrainWidth(constant: 80)
        priceButton.layer.cornerRadius = 16
        priceButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        priceButton.setTitleColor(.white, for: .normal)
        
        let stackView = VerticalStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [
                appIconImageView,
                VerticalStackView(arrangedSubviews: [
                    nameLabel,
                    UIStackView(arrangedSubviews: [priceButton, UIView()]),
                    UIView()
                    ], spacing: 12)
                ], customSpacing: 20),
            whatsNewLabel,
            releaseNotesLabel
            ], spacing: 16)
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 20, left: 20, bottom: 20, right: 20))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
