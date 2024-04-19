//
//  PaginationLoaderView.swift
//  ImageCrowlerApp
//
//  Created by Sandeep kushwaha on 18/04/24.
//

import Foundation
import UIKit

class PaginationLoaderView: UIView {
    let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.color = .black
        activityIndicatorView.tintColor = .black
        return activityIndicatorView
    }()
    var heightConstraint: NSLayoutConstraint?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(activityIndicatorView)
        self.backgroundColor = .gray
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        let heightConstraint = self.heightAnchor.constraint(equalToConstant: 50)
        heightConstraint.isActive = true
        self.heightConstraint = heightConstraint
    }
    
    func startAnimating() {
        self.heightConstraint?.constant = 50
        self.layoutIfNeeded()
        activityIndicatorView.startAnimating()
    }
    
    func stopAnimating() {
        self.heightConstraint?.constant = 0
        self.layoutIfNeeded()
        activityIndicatorView.stopAnimating()
    }
}
