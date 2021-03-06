//
//  ViewController.swift
//  TravelApp
//
//  Created by Pankaj Rawat on 21/01/17.
//  Copyright © 2017 Pankaj Rawat. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var trips: [Trip]?
    let cellId = "cellId"
    let trendingCellId = "trendingCellId"
    let userProfile = "userProfile"
    let notification = "notification"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        sharedData.homeController = self
        
        setupCollectionView()
        
        setUpNavBarButtons()
        
        if SharedData.sharedInstance.getToken() == "" {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        
        setUpMenuBar()
        
//        present(SearchTripViewController().self, animated: true, completion: nil)
    }
    
    func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(TrendingCell.self, forCellWithReuseIdentifier: trendingCellId)
        collectionView?.register(UserProfileCell.self, forCellWithReuseIdentifier: userProfile)
        collectionView?.register(NotificationCell.self, forCellWithReuseIdentifier: notification)
        
        collectionView?.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 50, 0)
        
        collectionView?.isPagingEnabled = true
    }
    
    func handleLogout() {
        sharedData.clearAll()
        GIDSignIn.sharedInstance().signOut()
        let loginController = LoginController()
        loginController.homeController = self
        present(loginController, animated: true, completion: nil)
        
    }
    
    func setUpNavBarButtons() {
        
        // Left Navigation Bar Button
        let searchIcon = UIImage(named: "search_icon")?.withRenderingMode(.alwaysTemplate)
        let searchBarButtonItem = UIBarButtonItem(image: searchIcon, landscapeImagePhone: searchIcon, style: .plain, target: self, action: #selector(handleSearch))
        searchBarButtonItem.tintColor = UIColor.white
        
        let navMoreIcon = UIImage(named: "nav_more_icon")?.withRenderingMode(.alwaysTemplate)
        let moreBarButtonItem = UIBarButtonItem(image: navMoreIcon, landscapeImagePhone: navMoreIcon, style: .plain, target: self, action: #selector(handleMore))
        moreBarButtonItem.tintColor = UIColor.white
        
        
        navigationItem.leftBarButtonItems = [moreBarButtonItem, searchBarButtonItem]
        
        // Left Navigation Bar Button
        let addIcon = UIImage(named: "plus-filled")?.withRenderingMode(.alwaysTemplate)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: addIcon, style: .plain, target: self, action: #selector(publishTrip))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.appCallToActionColor()
    }
    
    func publishTrip() {
        let createTripController = CreateTripController()
        present(createTripController, animated: true, completion: nil)
    }
    
    func handleSearch() {
        let searchTripController = SearchTripViewController()
        navigationController?.pushViewController(searchTripController, animated: true)
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = NSIndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath as IndexPath, at: [], animated: true)
    }
    
    let settingsLauncher = SettingsLauncher()
    func handleMore() {
        settingsLauncher.homeController = self
        settingsLauncher.showSettings()
    }
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    private func setUpMenuBar() {
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        menuBar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: menuBar)
        
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchor?.constant = scrollView.contentOffset.x / 4
    }
    
    override  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = NSIndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath as IndexPath, animated: true, scrollPosition: [])
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var identifier: String = ""
        
        switch indexPath.item {
        case 0:
            identifier = cellId
        case 1:
            identifier = trendingCellId
        case 2:
            identifier = notification
        case 3:
            identifier = userProfile
        default:
            identifier = cellId
        }
        if indexPath.item == 1 {
            identifier = trendingCellId
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 115)
    }
}

