//
//  AppsPageController.swift
//  LikeAppStore
//
//  Created by ivica petrsoric on 28/04/2019.
//  Copyright © 2019 ivica petrsoric. All rights reserved.
//

import UIKit

class AppsPageController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    private let headerId = "headerId"
    
    private var socialApps = [SocialApp]()
    private var groups = [AppGroup]()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.color = .black
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(AppsGroupCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(AppsPageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.fillSuperview()
        
        fetchData()
    }
    
    private func fetchData() {
        var group1: AppGroup?
        var group2: AppGroup?
        var group3: AppGroup?
        
        // help sync fetch data
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        Service.shared.fetchGames { (appGroup, err) in
            dispatchGroup.leave()
            group1 = appGroup
        }
        
        dispatchGroup.enter()
        Service.shared.fetchTopGrossing { (appGroup, err) in
            dispatchGroup.leave()
            group2 = appGroup
        }
        
        dispatchGroup.enter()
        Service.shared.fetchTopFree() { (appGroup, err) in
            dispatchGroup.leave()
            group3 = appGroup
        }
        
        dispatchGroup.enter()
        Service.shared.fetchSocialApps() { (apps, err) in
            dispatchGroup.leave()
            self.socialApps = apps ?? []
        }
        
        dispatchGroup.notify(queue: .main) {
            self.activityIndicatorView.stopAnimating()
            
            if let group = group1 {
                self.groups.append(group)
            }
            if let group = group2 {
                self.groups.append(group)
            }
            if let group = group3 {
                self.groups.append(group)
            }
            
            self.collectionView.reloadData()
        }
    }

    // header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AppsPageHeader
        header.appHeaderHorizontalController.socialApps = socialApps
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppsGroupCell
        let appGroups = groups[indexPath.item]
        cell.titleLabel.text = appGroups.feed.title
        cell.horizontalController.appGroup = appGroups
        
        cell.horizontalController.didSelectHandler = { [weak self] feedResult in
            let detailController = AppDetailController()
            detailController.navigationItem.title = feedResult.name
            self?.navigationController?.pushViewController(detailController, animated: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 0, right: 0)
    }
    
}
