//
//  BaseTodayCell.swift
//  LikeAppStore
//
//  Created by ivica petrsoric on 14/06/2019.
//  Copyright © 2019 ivica petrsoric. All rights reserved.
//

import UIKit

class BaseTodayCell: UICollectionViewCell {
    
    var todayItem: TodayItem!
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.transform = self.isHighlighted ? .init(scaleX: 0.9, y: 0.9) : .identity
            })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundView = UIView()
        
        addSubview(self.backgroundView!)
        self.backgroundView?.fillSuperview()
        self.backgroundView?.backgroundColor = .white
        self.backgroundView?.layer.cornerRadius = 16
        
        self.backgroundView?.layer.shadowOpacity = 0.1
        self.backgroundView?.layer.shadowRadius = 10
        self.backgroundView?.layer.shadowOffset = .init(width: 0, height: 10)
        self.backgroundView?.layer.shouldRasterize = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}
