//
//  MusicController.swift
//  LikeAppStore
//
//  Created by ivica petrsoric on 15/06/2019.
//  Copyright © 2019 ivica petrsoric. All rights reserved.
//

import UIKit

class MusicController: BaseListController, UICollectionViewDelegateFlowLayout{
    
    private let cellId = "cellId"
    private let footerId = "footerId"
    
    private var results = [Result]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(TrackCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(MusicLoadigFooter.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: footerId)
        
        fetchData(offset: 0)
    }
    
    private let searchTerm = "taylor"
    private var isPaginating = false
    private var isDonePaginating = false
    
    private func fetchData(offset: Int) {
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&offset=\(offset)&limit=20"
        Service.shared.fetchGenericJSONData(urlString: urlString) { (searchResult: SearchResult?, err) in
            if let err = err {
                print("Failed to paginate data", err)
            }
            
            sleep(2)
            
            if searchResult?.results.count == 0 {
                self.isDonePaginating = true
            }
            
            self.results += searchResult?.results ?? []
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
            self.isPaginating = false
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let height: CGFloat = isDonePaginating ? 0 : 100
        return .init(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TrackCell
        cell.track = results[indexPath.item]
        
        //initiate pagination
        if indexPath.item == results.count - 1 && !isPaginating {
            isPaginating = true
            fetchData(offset: results.count)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 100)
    }
}
