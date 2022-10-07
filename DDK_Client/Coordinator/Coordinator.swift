//
//  Coordinator.swift
//  DDK_Client
//
//  Created by iOS Developer on 2022/08/19.
//

import UIKit
import RxCocoa
import RxSwift

protocol CoordinatorSpec {
    func setRoot(_ type: SceneType) -> UIViewController
    func present(_ type: SceneType)
    func presentFullScreen(_ type: SceneType)
    func dismiss()
}

class Coordinator: CoordinatorSpec {
    
    static let instance = Coordinator()
    private let di = DIContainer.instance
    private var rootViewController: UIViewController?
    
    private init() { }
    
    @discardableResult
    func setRoot(_ type: SceneType) -> UIViewController {
        let target = viewController(type)
        self.rootViewController = target
        return target
    }
    
    func setRootViewController(_ viewController: UIViewController) {
        self.rootViewController = viewController
    }
    
    func present(_ type: SceneType) {
        let target = viewController(type)
        self.rootViewController?.present(
            target,
            animated: true
        )
    }
    
    func presentFullScreen(_ type: SceneType) {
        let target = viewController(type)
        target.modalPresentationStyle = .fullScreen
        self.rootViewController?.present(
            target,
            animated: true
        )
    }
    
    func dismiss() {
        self.rootViewController?.dismiss(animated: true)
    }
    
}

extension Coordinator {
    
    private func viewController(_ type: SceneType) -> UIViewController {
        switch type {
        case .login:
            return di.container.resolve(
                LoginViewController.self,
                argument: false
            )!
            
        case .signUp:
            return di.container.resolve(
                SignUpViewController.self,
                argument: false
            )!
            
        case let .chatRoom(name):
            return di.container.resolve(
                ChatRoomViewController.self,
                arguments: name, false
            )!
            
        }
    }
    
}

extension Coordinator: ReactiveCompatible { }

extension Reactive where Base: Coordinator {
    
    var root: Binder<SceneType> {
        return Binder(base) { coordinator, sceneType in
            coordinator.setRoot(sceneType)
        }
    }
    
    var present: Binder<SceneType> {
        return Binder(base) { coordinator, sceneType in
            coordinator.present(sceneType)
        }
    }
    
    var presentFullScreen: Binder<SceneType> {
        return Binder(base) { coordinator, sceneType in
            coordinator.presentFullScreen(sceneType)
        }
    }
    
    var dismiss: Binder<Void> {
        return Binder(base) { coordinator, _ in
            coordinator.dismiss()
        }
    }
    
}
