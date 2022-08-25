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
            name: Consts.StoryBoard.main.rawValue,
            bundle: nil
        )
        let identifier = String(describing: type)
        return storyboard.instantiateViewController(withIdentifier: identifier) as? T
    }
    
    func setActivityIndicator(isLoading: Bool) {
        let identifier = Consts.Idenfitier.activityIndicator.rawValue
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
    
    func isActivityIndicatorAnimating() -> Bool {
        let identifier = Consts.Idenfitier.activityIndicator.rawValue
        guard let indicatorView = (self.view.subviews.filter {
            $0.accessibilityIdentifier == identifier
        }.first) as? UIActivityIndicatorView
        else {
            return false
        }
        return indicatorView.isAnimating
    }
    
    func showAlert(
        title: String?,
        message: String?
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "확인",
            style: .default
        )
        alert.addAction(okAction)
        self.present(
            alert,
            animated: true
        )
    }
    
}


extension Reactive where Base: UIViewController {
    
    var setActivityIndicator: Binder<Bool> {
        return Binder(base) { viewController, isLoading in
            viewController.setActivityIndicator(isLoading: isLoading)
        }
    }
    
    var showAlert: Binder<(title: String?, message: String?)> {
        return Binder(base) { viewController, args in
            viewController.showAlert(
                title: args.title,
                message: args.message
            )
        }
    }
    
}
