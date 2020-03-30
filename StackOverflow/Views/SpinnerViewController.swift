//
//  SpinnerViewController.swift
//  StackItUp
//
//  Created by mcs on 3/27/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SpinnerViewController: UIViewController {
    var spinner = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .ballRotateChase, color: .systemBlue, padding: 10)

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
