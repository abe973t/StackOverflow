//
//  LoginView.swift
//  StackItUp
//
//  Created by mcs on 3/13/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit
import WebKit
import RNCryptor

// swiftlint:disable trailing_whitespace
// swiftlint:disable line_length
class LoginView: UIView {
        
    weak var controller: MainViewController?
    
    let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .black
        return webView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        
        if let url = URLBuilder.authURL(clientID: 17333, scope: "write_access", redirectURI: "https://stackexchange.com/oauth/login_success") {
            // FIXME: doesn't work with the Google auth
            webView.navigationDelegate = self
            webView.load(URLRequest(url: url))
        }
    }
    
    func addViews() {
        addSubview(webView)
    
        addContraints()
    }
    
    func addContraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoginView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let url = webView.url, url.absoluteString.contains("access_token") {
            if let tokenData = url.absoluteString.substring(with: 59..<83).data(using: .utf8) {
                let encryptedToken = RNCryptor.encrypt(data: tokenData, withPassword: Constants.decryptKey.rawValue)
                
//                let alert = UIAlertController(title: "Set Password", message: "Create a password to access the stackexchange server", preferredStyle: .alert)
//                alert.addTextField()
//                alert.textFields?.first?.isSecureTextEntry = true
//                let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alert] _ in
//                    if !alert.textFields![0].text!.isEmpty {
//                        let pass = alert.textFields![0].text
//                        Constants.decryptKey.rawValue = pass!
//                        encryptedToken = RNCryptor.encrypt(data: tokenData, withPassword: pass!)
//                    }
//                }
//                alert.addAction(submitAction)
//                controller?.navigationController?.present(alert, animated: true, completion: nil)
                
                let defaults = UserDefaults.standard
                defaults.set(encryptedToken, forKey: "access_token")
                controller?.loadMainScreen()
            }
        }
    }
}
