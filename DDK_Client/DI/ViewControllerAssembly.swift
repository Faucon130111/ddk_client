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
            let reactor = r.resolve(LoginViewReactor.self)!
            reactor.isStubEnabled = isStubEnabled
            let viewController = UIViewController.instantiate(of: LoginViewController.self)!
            viewController.reactor = reactor
            return viewController
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
    }
    
}
