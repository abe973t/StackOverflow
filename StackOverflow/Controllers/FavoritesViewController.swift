//
//  FavoritesViewController.swift
//  StackItUp
//
//  Created by mcs on 3/29/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    var favoritesView = FavoriteView()
    let child = SpinnerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favorite Questions"
        
        view = favoritesView
        favoritesView.controller = self
    }
    
    func createSpinnerView() {
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func removeSpinnerView() {
        DispatchQueue.main.async {
            self.child.willMove(toParent: nil)
            self.child.view.removeFromSuperview()
            self.child.removeFromParent()
        }
    }
}
