//
//  UINavigation+extension.swift
//  ImageCrowlerApp
//
//  Created by Sandeep kushwaha on 18/04/24.
//

import Foundation
import UIKit
extension UINavigationBar {
    func addBottomLine(color: UIColor = .black, height: CGFloat = 0.7) {
        let bottomLine = UIView(frame: CGRect(x: 0, y: frame.size.height - height, width: frame.size.width, height: height))
        bottomLine.backgroundColor = color
        bottomLine.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        addSubview(bottomLine)
    }
}
