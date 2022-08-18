//
//  UIViewController+Extension.swift
//  DDK_Client
//
//  Created by iOS Developer on 2022/08/16.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

extension UIViewController {
    
    static func instantiate<T: UIViewController>(of type: T.Type) -> T? {
        let storyboard = UIStoryboard(
            name: "Main",
            bundle: nil
        )
        let identifier = String(describing: type)
        return storyboard.instantiateViewController(withIdentifier: identifier) as? T
    }
    
    func setActivityIndicator(isLoading: Bool) {
        let identifier = "activityIndicator"
        var activityIndicatorView: UIActivityIndicatorView!
        
        if let indicatorView = (self.view.subviews.filter {
            $0.accessibilityIdentifier == identifier
        }.first) as? UIActivityIndicatorView {
            activityIndicatorView = indicatorView
        } else {
            activityIndicatorView = UIActivityIndicatorView(style: .medium)
            activityIndicatorView.hidesWhenStopped = true
            activityIndicatorView.accessibilityIdentifier = identifier
            self.view.addSubview(activityIndicatorView)
            activityIndicatorView.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
        
        if isLoading {
            self.view.isUserInteractionEnabled = false
            activityIndicatorView.startAnimating()
        } else {
            self.view.isUserInteractionEnabled = true
            activityIndicatorView.stopAnimating()
        }
    }
    
}


extension Reactive where Base: UIViewController {
    
    var setActivityIndicator: Binder<Bool> {
        return Binder(base) { viewController, isLoading in
            viewController.setActivityIndicator(isLoading: isLoading)
        }
    }
    
}
