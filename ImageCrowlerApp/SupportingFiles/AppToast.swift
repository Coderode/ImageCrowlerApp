//
//  AppToast.swift
//  ImageCrowlerApp
//
//  Created by Sandeep kushwaha on 18/04/24.
//

import Foundation
import UIKit
class Toast {
    class private func showAlert(backgroundColor:UIColor, textColor:UIColor, message:String) {
        guard let window = UIApplication.shared.windows.first else { return }
        let button = UIButton(frame: CGRect(x: 32, y: window.frame.height - window.safeAreaInsets.bottom - 70, width: window.frame.size.width - 64, height: 55))
        button.backgroundColor = backgroundColor
        button.setTitle(message, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.numberOfLines = 4
        button.alpha = 1
        button.isEnabled = false
        button.isUserInteractionEnabled = false
        button.layer.cornerRadius = 10
        button.titleEdgeInsets = UIEdgeInsets(top: 5, left: 25, bottom: 5, right: 10)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        if (button.titleLabel?.frame.size.height ?? 0 + 20) > 55 {
            button.frame.size.height = ((button.titleLabel?.frame.size.height ?? 0) - 5)
        }
        let onCompletion = {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                button.removeFromSuperview()
            }
        }
        window.addSubview(button)
        _ = onCompletion()
    }

    class func showToastMessage(message:String) {
        showAlert(backgroundColor: .lightGray, textColor: .black, message: message)
    }
    class func showErrorMessage(error: Error) {
        var message = error.localizedDescription
        if let networkError = error as? ErrorResponse {
            message = "\(networkError.error)"
        }
        if let networkError = error as? NetworkError {
            message = networkError.rawValue
        }
        showAlert(backgroundColor: .lightGray, textColor: .black, message: message)
    }
}
