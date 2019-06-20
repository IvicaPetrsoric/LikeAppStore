//
//  TodayController.swift
//  LikeAppStore
//
//  Created by ivica petrsoric on 11/06/2019.
//  Copyright © 2019 ivica petrsoric. All rights reserved.
//

import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {

    private var items = [TodayItem]()
    
    private var asctivityIndicatorView: UIActivityIndicatorView = {
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
    
    private let bluerVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(bluerVisualEffectView)
        bluerVisualEffectView.fillSuperview()
        bluerVisualEffectView.alpha = 0
        
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
                TodayItem(category: "LIFE HACK", title: "Utilizing your Time", image: #imageLiteral(resourceName: "garden"),
                          description: "All the tools and apps you need to intelligently organize your life the right way.",
                          bacgrkoundColor: .white, cellType: .single, apps: []),
                TodayItem(category: "First Cell", title: topGrossingGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"),
                          description: "1. All the tools and apps you need to intelligently organize your life the right way.",
                          bacgrkoundColor: .white, cellType: .multiple, apps: topGrossingGroup?.feed.results ?? []),
                TodayItem(category: "Second Cell", title: gamesGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"),
                          description: "2. All the tools and apps you need to intelligently organize your life the right way.",
                          bacgrkoundColor: .white, cellType: .multiple, apps: gamesGroup?.feed.results ?? []),
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
                present(BackEnabledNavigationController(rootViewController: fullController), animated: true)
                return
            }
            
            superview = superview?.superview
        }
    }
    
    private var startingFrame: CGRect?
    private var appFullscreenController: AppFullScreenController!
    private var anchoredConstraint: AnchoredConstraints?
    
    private func showDailyFullScreen(_ indexPath: IndexPath) {
        let fullController = TodayMultipleAppController(mode: .fullScreen)
        fullController.apps = items[indexPath.item].apps
        present(BackEnabledNavigationController(rootViewController: fullController), animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch items[indexPath.item].cellType {
            case .multiple:
                showDailyFullScreen(indexPath)
            default:
                showSingleAppFullscreen(indexPath: indexPath)
        }
    }
    
    private func showSingleAppFullscreen(indexPath: IndexPath) {
        setupAppFullscreenController(indexPath)
        setupAppFullscreenStartingPosition(indexPath)
        beginAnimationAppFullscreen()
    }
    
    private func setupAppFullscreenController(_ indexPath: IndexPath) {
        let appFullscreenController = AppFullScreenController()
        appFullscreenController.todayItem = items[indexPath.item]
        appFullscreenController.dismissHandler = {
            self.handleAppFullscreenDismissal()
        }
        
        appFullscreenController.view.layer.cornerRadius = 16
        self.appFullscreenController = appFullscreenController
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
        gesture.delegate = self
        appFullscreenController.view.addGestureRecognizer(gesture)
    }
    
    private var appFullscreenBeginOffset: CGFloat = 0
    
    @objc private func handleDrag(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            appFullscreenBeginOffset = appFullscreenController.tableView.contentOffset.y
        }
        
        if appFullscreenController.tableView.contentOffset.y > 0 {
            return
        }
        
        let translationY = gesture.translation(in: appFullscreenController.view).y
        
        if gesture.state == .changed {
            if translationY > 0 {
                let trueOffset = translationY - appFullscreenBeginOffset
                var scale = 1 - trueOffset / 1000
                
                scale = min(1, scale)
                scale = max(0.5, scale)
                
                let transform: CGAffineTransform = .init(scaleX: scale, y: scale)
                self.appFullscreenController.view.transform = transform
            }
        } else if gesture.state == .ended {
            if translationY > 0 {
                handleAppFullscreenDismissal()
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    private func setupAppFullscreenStartingPosition(_ indexPath: IndexPath) {
        let fullscreenView = appFullscreenController.view!
        
        view.addSubview(fullscreenView)
        addChild(appFullscreenController)
        
        self.collectionView.isUserInteractionEnabled = false
        
        setupStartingCellFrame(indexPath)
        
        guard let startingFrame = self.startingFrame else { return }
        
        self.anchoredConstraint = fullscreenView.anchor(top: view.topAnchor, leading: view.leadingAnchor,
                                                        bottom: nil, trailing: nil,
                                                        padding: .init(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0),
                                                        size: .init(width: startingFrame.width, height: startingFrame.height))

        self.view.layoutIfNeeded()
    }
    
    private func setupStartingCellFrame(_ indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        // absolute coordinate
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        self.startingFrame = startingFrame
    }
    
    private func beginAnimationAppFullscreen() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.bluerVisualEffectView.alpha = 1

            self.anchoredConstraint?.top?.constant = 0
            self.anchoredConstraint?.leading?.constant = 0
            self.anchoredConstraint?.width?.constant = self.view.frame.width
            self.anchoredConstraint?.height?.constant = self.view.frame.height
            
            // start animations
            self.view.layoutIfNeeded()
            
            self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            
            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
            cell.todayCell.topConstraint.constant = 48
            cell.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc private func handleAppFullscreenDismissal() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.bluerVisualEffectView.alpha = 0

            self.appFullscreenController.tableView.contentOffset = .zero
            self.appFullscreenController.view.transform = .identity
            
            guard let startingFrame = self.startingFrame else { return }
            
            self.anchoredConstraint?.top?.constant = startingFrame.origin.y
            self.anchoredConstraint?.leading?.constant = startingFrame.origin.x
            self.anchoredConstraint?.width?.constant = startingFrame.width
            self.anchoredConstraint?.height?.constant = startingFrame.height

            self.view.layoutIfNeeded()

            self.tabBarController?.tabBar.transform = .identity
            
            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
            self.appFullscreenController.closeButton.alpha = 0
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
