//
//  ReactorAssembly.swift
//  DDK_Client
//
//  Created by iOS Developer on 2022/08/18.
//

import Swinject

class ReactorAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(LoginViewReactor.self) { r in
            let socketService = r.resolve(SocketService.self)!
            return LoginViewReactor(socketService: socketService)
        }
        container.register(ChatViewReactor.self) { (r: Resolver, name: String) in
            let socketService = r.resolve(SocketService.self)!
            return ChatViewReactor(
                name: name,
                socketService: socketService
            )
        }
    }
    
}
