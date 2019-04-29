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
                let app = resutl?.results.first
                self.app = app
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    var app: Result?
    
    private let detailsCellId = "detailsCellId"
    private let previewCellId = "previewCellId"
    private let reviewCellId = "reviewCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(AppDetailsCell.self, forCellWithReuseIdentifier: detailsCellId)
        collectionView.register(PreviewCell.self, forCellWithReuseIdentifier: previewCellId)
        collectionView.register(ReviewRowCell.self, forCellWithReuseIdentifier: reviewCellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailsCellId, for: indexPath) as! AppDetailsCell
            cell.app = app
            return cell
        } else if indexPath.item == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: previewCellId, for: indexPath) as! PreviewCell
            cell.horizontalController.app = app
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewCellId, for: indexPath) as! ReviewRowCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 280
        
        if indexPath.item == 0 {
            let dummyCell = AppDetailsCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1000))
            dummyCell.app = app
            dummyCell.layoutIfNeeded()
            let estimatedSize = dummyCell.systemLayoutSizeFitting(CGSize(width: view.frame.width, height: 1000))
            height = estimatedSize.height
        } else if indexPath.item == 1{
            height = 500
        } else {
            height = 280
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
}
