//
//  ViewControllerAssembly.swift
//  DDK_Client
//
//  Created by iOS Developer on 2022/08/18.
//

import Swinject

class ViewControllerAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(LoginViewController.self) { r in
            let reactor = r.resolve(LoginViewReactor.self)!
            let viewController = UIViewController.instantiate(of: LoginViewController.self)!
            viewController.reactor = reactor
            return viewController
        }
        container.register(ChatViewController.self) { (r: Resolver, name: String) in
            let reactor = r.resolve(
                ChatViewReactor.self,
                argument: name
            )!
            let viewController = UIViewController.instantiate(of: ChatViewController.self)!
            viewController.reactor = reactor
            return viewController
        }
    }
    
}
