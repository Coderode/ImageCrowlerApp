//
//  UIView+LoadingIndicator.swift
//  ImageCrowlerApp
//
//  Created by Sandeep kushwaha on 17/04/24.
//

import Foundation
import UIKit

extension UIView {
    func showLoader() {
        self.removeLoader()
        DispatchQueue.main.async {
            let loader = UIActivityIndicatorView(style: .medium)
            loader.color = .gray
            loader.translatesAutoresizingMaskIntoConstraints = false
            loader.startAnimating()
            
            self.addSubview(loader)
            
            NSLayoutConstraint.activate([
                loader.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                loader.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
        }
    }
    
    func removeLoader() {
        DispatchQueue.main.async {
            for subview in self.subviews {
                if let loader = subview as? UIActivityIndicatorView {
                    loader.stopAnimating()
                    loader.removeFromSuperview()
                }
            }
        }
    }
}
