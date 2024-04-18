//
//  ImageCrowlerGridCVC.swift
//  ImageCrowlerApp
//
//  Created by Sandeep kushwaha on 16/04/24.
//

import Foundation
import UIKit
class ImageCrowlerGridCVC: UICollectionViewCell {
    var imageLoadOperation: Operation?
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
    func setData(thumbnail: Thumbnail) {
        let urlString = "\(thumbnail.domain)/\(thumbnail.basePath)/0/\(thumbnail.key)"
        let url = URL(string: urlString)!
        let operation = self.imageView.loadImage(url: url, placeHolderImage:  UIImage(named: "placeHolderImage")) // ImageView Extension
        self.imageLoadOperation = operation
    }
    
    private func setupViews() {
        addSubview(imageView)
        DispatchQueue.main.async {
            NSLayoutConstraint.activate([
                self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
                self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        }
    }
}
