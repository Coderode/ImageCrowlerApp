//
//  File.swift
//  ImageCrowlerApp
//
//  Created by Sandeep kushwaha on 17/04/24.
//

import Foundation
import UIKit
extension UIImageView {
    func loadImage(url: URL, placeHolderImage: UIImage? = nil) -> Operation {
        self.image = placeHolderImage
        self.showLoader()
        let operation = ImageLoadManager.shared.fetchImageData(url: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.image = image
                self?.removeLoader()
            }
        }
        return operation
    }
}
