//
//  NetworkManager.swift
//  Nidhi_Bhadasia_102722
//
//  Created by Guest1 on 10/27/22.
//

import Foundation
import UIKit
import SwiftUI

class NetworkManager: NSObject {
    static let shared = NetworkManager()
    
    // MARK: - Initialization
    private override init() {
        // Created sigleton object
        // Private Initialization
    }
    
    // MARK: - API functions
    func fetchEmployeeList(
        api: String,
        completion: @escaping ([Employee]?, String?) -> Void
    ){
        // Get API URL
        guard let url = URL(string: api) else {
            completion(nil, Constant.AlertMessage.urlNotFound)
            return
        }
        // Fetch Data
        URLSession.shared.dataTask(with:url, completionHandler: {(data, response, error) -> Void in
            guard let dataResponse = data, error == nil else {
                completion(nil, error?.localizedDescription ?? "Response Error")
                return
            }
            do {
                //dataResponse received from a network request
                let decoder = JSONDecoder()
                //Decode JSON Response Data
                let arDictionary = try decoder.decode([String: [Employee]].self, from: dataResponse)
                if let arEmployee = arDictionary["employees"], !arEmployee.isEmpty {
                    completion(arEmployee, nil)
                } else {
                    completion(nil, Constant.AlertMessage.emptyList)
                }
                
            } catch let error {
                completion(nil, error.localizedDescription)
            }
        }).resume()
    }
}

extension UIImageView {
    func fetchEmployeeImage(withUrl urlString : String) {
        
        let imageCache = NSCache<NSString, UIImage>()
        guard let url = URL(string: urlString) else { return }
        self.image = nil
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }
        
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .medium)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.center
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                DispatchQueue.main.async {
                    self.image = UIImage(systemName: "person.fill")
                    activityIndicator.removeFromSuperview()
                }
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    activityIndicator.removeFromSuperview()
                }
            }
            
        }).resume()
    }
}

