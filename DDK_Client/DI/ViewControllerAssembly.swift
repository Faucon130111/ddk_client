//
//  ViewControllerAssembly.swift
//  DDK_Client
//
//  Created by iOS Developer on 2022/08/18.
//

import Swinject

class ViewControllerAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(LoginViewController.self) { (r: Resolver, isStubEnabled: Bool) in
            let view = r.resolve(LoginView.self)!
            let reactor = r.resolve(LoginViewReactor.self)!
            reactor.isStubEnabled = isStubEnabled
            return LoginViewController(
                view: view,
                reactor: reactor
            )
        }
        
        container.register(ChatRoomViewController.self) { (r: Resolver, name: String, isStubEnabled: Bool) in
            let reactor = r.resolve(
                ChatRoomViewReactor.self,
                argument: name
            )!
            reactor.isStubEnabled = isStubEnabled
            let viewController = UIViewController.instantiate(of: ChatRoomViewController.self)!
            viewController.reactor = reactor
            return viewController
        }
        
        container.register(SignUpViewController.self) { (r: Resolver, isStubEnabled: Bool) in
            let view = r.resolve(SignUpView.self)!
            let reactor = r.resolve(SignUpViewReactor.self)!
            reactor.isStubEnabled = isStubEnabled
            return SignUpViewController(
                view: view,
                reactor: reactor
            )
        }
    }
    
}
