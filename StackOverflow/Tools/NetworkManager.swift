//
//  NetworkManagerViewController.swift
//  NetworkManager
//
//  Created by mcs on 1/27/20.
//  Copyright © 2020 mcs. All rights reserved.
//

import UIKit

// swiftlint:disable trailing_whitespace
class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func get(url: URL, completion: @escaping (Data?, Error?) -> ()) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            if let error = error {
                completion(nil, error)
            }
            
            if let data = data {
                completion(data, nil)
            }
        }
        
        task.resume()
    }
    
    func post(url: URL, data: Data?, completion: @escaping (Data?, Error?) -> ()) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
            }
            
            if let data = data {
                completion(data, nil)
            }
        }
        
        task.resume()
    }
}
