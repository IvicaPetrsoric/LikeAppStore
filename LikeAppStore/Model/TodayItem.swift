//
//  TodayItem.swift
//  LikeAppStore
//
//  Created by ivica petrsoric on 14/06/2019.
//  Copyright © 2019 ivica petrsoric. All rights reserved.
//

import UIKit

struct TodayItem {
    
    let category: String
    let title: String
    let image: UIImage
    let description: String
    let bacgrkoundColor: UIColor
    
    let cellType: CellType
    
    enum CellType: String {
        case single, multiple
    }
    
}

