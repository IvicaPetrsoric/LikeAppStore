//
//  TodayMultipleAppController.swift
//  LikeAppStore
//
//  Created by ivica petrsoric on 14/06/2019.
//  Copyright © 2019 ivica petrsoric. All rights reserved.
//

import UIKit

class TodayMultipleAppController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    var apps = [FeedResult]()
    
    private let cellId = "cellId"
    
    private let mode: Mode
    
    private let spacing: CGFloat = 16
    
    enum Mode {
        case small, fullScreen
    }
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close_button"), for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    init(mode: Mode) {
        self.mode = mode
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mode == .fullScreen {
            setupCloseButton()
            navigationController?.isNavigationBarHidden = true
        } else {
            collectionView.isScrollEnabled = false
        }
        
        collectionView.backgroundColor = .white
        collectionView.register(MultipleAppCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.topAnchor, leading: nil,
                           bottom: nil, trailing: view.trailingAnchor,
                           padding: .init(top: 16, left: 0, bottom: 0, right: 16),
                           size: .init(width: 32, height: 32))
    }
    
    @objc private func handleDismiss() {
        dismiss(animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if mode == .fullScreen {
            return apps.count
        }
        
        return min(4,apps.count)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MultipleAppCell
        cell.app = apps[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appId = self.apps[indexPath.item].id
        let appDetailsController = AppDetailController(appId: appId)
        navigationController?.pushViewController(appDetailsController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 68
        let width: CGFloat = mode == .fullScreen ? view.frame.width - 48 : view.frame.width
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if mode == .fullScreen {
            return .init(top: 32, left: 24, bottom: 12, right: 24)
        }
        
        return .zero
    }
    
}
