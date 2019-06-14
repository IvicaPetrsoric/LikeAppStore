//
//  TodayController.swift
//  LikeAppStore
//
//  Created by ivica petrsoric on 11/06/2019.
//  Copyright © 2019 ivica petrsoric. All rights reserved.
//

import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout {
    
//    let items = [
//        TodayItem(category: "LIFE HACK", title: "Utilizing your Time", image: #imageLiteral(resourceName: "garden"),
//                  description: "All the tools and apps you need to intelligently organize your life the right way.",
//                  bacgrkoundColor: .white, cellType: .single),
//        TodayItem(category: "Second Cell", title: "Test-Drive These CarPlay Apps", image: #imageLiteral(resourceName: "garden"),
//                  description: "All the tools and apps you need to intelligently organize your life the right way.",
//                  bacgrkoundColor: .white, cellType: .multiple),
//        TodayItem(category: "Holidays", title: "Travel on a Budget", image: #imageLiteral(resourceName: "holiday"),
//                  description: "Find out all you need to know on how to travel without packing everything!",
//                  bacgrkoundColor: #colorLiteral(red: 0.9789804816, green: 0.9736877084, blue: 0.7382865548, alpha: 1), cellType: .single),
//        TodayItem(category: "MULTIPLE CELL", title: "Test-Drive These CarPlay Apps", image: #imageLiteral(resourceName: "garden"),
//                  description: "All the tools and apps you need to intelligently organize your life the right way.",
//                  bacgrkoundColor: .white, cellType: .multiple),
//    ]
    
    var items = [TodayItem]()
    
    var asctivityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.color = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.superview?.setNeedsLayout()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(asctivityIndicatorView)
        asctivityIndicatorView.centerInSuperview()
        
        fetchData()
        
        collectionView.backgroundColor = #colorLiteral(red: 0.9520952106, green: 0.9459629655, blue: 0.9522011876, alpha: 1)
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
        collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    private func fetchData() {
        let dispatchGroup = DispatchGroup()
        var topGrossingGroup: AppGroup?
        var gamesGroup: AppGroup?
        
        dispatchGroup.enter()
        Service.shared.fetchTopGrossing { (appGroup, err) in
            topGrossingGroup = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Service.shared.fetchGames { (appGroup, err) in
            gamesGroup = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            print("Finished fetching")
            
            self.asctivityIndicatorView.stopAnimating()
            
            self.items = [
                TodayItem(category: "First Cell", title: topGrossingGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"),
                          description: "1. All the tools and apps you need to intelligently organize your life the right way.",
                          bacgrkoundColor: .white, cellType: .multiple, apps: topGrossingGroup?.feed.results ?? []),
                TodayItem(category: "Second Cell", title: gamesGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"),
                          description: "2. All the tools and apps you need to intelligently organize your life the right way.",
                          bacgrkoundColor: .white, cellType: .multiple, apps: gamesGroup?.feed.results ?? []),
                TodayItem(category: "LIFE HACK", title: "Utilizing your Time", image: #imageLiteral(resourceName: "garden"),
                          description: "All the tools and apps you need to intelligently organize your life the right way.",
                          bacgrkoundColor: .white, cellType: .single, apps: []),
                TodayItem(category: "Holidays", title: "Travel on a Budget", image: #imageLiteral(resourceName: "holiday"),
                          description: "Find out all you need to know on how to travel without packing everything!",
                          bacgrkoundColor: #colorLiteral(red: 0.9789804816, green: 0.9736877084, blue: 0.7382865548, alpha: 1), cellType: .single, apps: []),
            ]
            
            self.collectionView.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = items[indexPath.item].cellType.rawValue
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BaseTodayCell
        cell.todayItem = items[indexPath.item]
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMultipleAppsTap))
        (cell as? TodayMultipleAppCell)?.multipleAppsController.collectionView.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    @objc private func handleMultipleAppsTap(gesture: UIGestureRecognizer) {
        let collectionView = gesture.view
        
        var superview = collectionView?.superview
        
        while  superview != nil  {
            if let cell = superview as? TodayMultipleAppCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                
                let apps = self.items[indexPath.item].apps
                
                let fullController = TodayMultipleAppController(mode: .fullScreen)
                fullController.apps = apps
                present(fullController, animated: true)
                return
            }
            
            superview = superview?.superview
        }
    }
    
    private var startingFrame: CGRect?
    private var appFullscreenController: AppFullScreenController!
    private var topConstraint: NSLayoutConstraint?
    private var leadingConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if items[indexPath.item].cellType == .multiple {
            let fullController = TodayMultipleAppController(mode: .fullScreen)
            fullController.apps = items[indexPath.item].apps
            present(BackEnabledNavigationController(rootViewController: fullController), animated: true)
            return
        }
        
        let appFullscreenController = AppFullScreenController()
        appFullscreenController.todayItem = items[indexPath.item]
        appFullscreenController.dismissHandler = {
            self.handleRemoveRedView()
        }
        
        let fullscreenView = appFullscreenController.view!
        
        view.addSubview(fullscreenView)
        addChild(appFullscreenController)
        
        self.appFullscreenController = appFullscreenController
        self.collectionView.isUserInteractionEnabled = false
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        // absolute coordinate
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        self.startingFrame = startingFrame
        
        fullscreenView.translatesAutoresizingMaskIntoConstraints = false
        
        topConstraint = fullscreenView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
        leadingConstraint = fullscreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingFrame.origin.x)
        widthConstraint = fullscreenView.widthAnchor.constraint(equalToConstant: startingFrame.width)
        heightConstraint = fullscreenView.heightAnchor.constraint(equalToConstant: startingFrame.height)
        
        [topConstraint, leadingConstraint, widthConstraint, heightConstraint].forEach({$0?.isActive = true})
        
        self.view.layoutIfNeeded()

        fullscreenView.layer.cornerRadius = 16

        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.topConstraint?.constant = 0
            self.leadingConstraint?.constant = 0
            self.widthConstraint?.constant = self.view.frame.width
            self.heightConstraint?.constant = self.view.frame.height
            
            // start animations
            self.view.layoutIfNeeded()
            
            self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            
            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
            cell.todayCell.topConstraint.constant = 48
            cell.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc private func handleRemoveRedView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.appFullscreenController.tableView.contentOffset = .zero

            guard let startingFrame = self.startingFrame else { return }
            
            self.topConstraint?.constant = startingFrame.origin.y
            self.leadingConstraint?.constant = startingFrame.origin.x
            self.widthConstraint?.constant = startingFrame.width
            self.heightConstraint?.constant = startingFrame.height

            self.view.layoutIfNeeded()

            self.tabBarController?.tabBar.transform = .identity
            
            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
            cell.todayCell.topConstraint.constant = 24
            cell.layoutIfNeeded()
        }, completion: { _ in
            self.appFullscreenController.view?.removeFromSuperview()
            self.appFullscreenController.removeFromParent()
            self.collectionView.isUserInteractionEnabled = true
        })
    }
    
    static let cellSize: CGFloat = 500
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: TodayController.cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
    
}
