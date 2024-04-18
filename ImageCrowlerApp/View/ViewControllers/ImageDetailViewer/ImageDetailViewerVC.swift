//
//  ImageDetailViewer.swift
//  ImageCrowlerApp
//
//  Created by Sandeep kushwaha on 17/04/24.
//

import Foundation
import UIKit
class ImageDetailViewerVC: UIViewController {
    var data: FeedDataModelElement!
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        title.textColor = .black
        title.textAlignment = .center
        title.numberOfLines = 0
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    var viewModel: ImageCrowlerVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        self.navigationItem.title = "Image Viewer"
        self.navigationItem.setHidesBackButton(false, animated: false)
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .black
        self.setupViews()
        self.loadData()
    }
    
    class func `init`(data: FeedDataModelElement) -> UIViewController {
        let vc = ImageDetailViewerVC()
        vc.data = data
        return vc
    }
    
    private func setupViews() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        let topSafeArea = statusBarHeight + (view.window?.safeAreaInsets.top ?? 0)
        self.view.addSubview(titleLabel)
        self.view.addSubview(imageView)
        titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topSafeArea + navigationBarHeight + 20).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.7).isActive = true
    }
    private func loadData() {
        self.titleLabel.text = self.data.title
        let thumbnail = data.thumbnail
        let urlString = "\(thumbnail.domain)/\(thumbnail.basePath)/0/\(thumbnail.key)"
        let url = URL(string: urlString)!
        self.imageView.loadImage(url: url)
    }
}
