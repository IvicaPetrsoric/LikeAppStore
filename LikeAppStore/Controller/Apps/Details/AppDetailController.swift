//
//  AppDetailController.swift
//  LikeAppStore
//
//  Created by ivica petrsoric on 28/04/2019.
//  Copyright © 2019 ivica petrsoric. All rights reserved.
//

import UIKit

class AppDetailController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    var appId: String? {
        didSet {
            let urlString = "https://itunes.apple.com/lookup?id=\(appId ?? "")"
            Service.shared.fetchGenericJSONData(urlString: urlString) { (resutl: SearchResult?, err) in
                
            }
        }
    }
    
    private let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(AppDetailsCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppDetailsCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    
}
