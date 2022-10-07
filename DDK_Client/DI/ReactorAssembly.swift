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
            let networkService = r.resolve(NetworkService.self)!
            return LoginViewReactor(networkService: networkService)
        }
        
        container.register(ChatRoomViewReactor.self) { (r: Resolver, name: String) in
            let socketService = r.resolve(SocketService.self)!
            return ChatRoomViewReactor(
                name: name,
                socketService: socketService
            )
        }
        
        container.register(SignUpViewReactor.self) { r in
            let networkService = r.resolve(NetworkService.self)!
            return SignUpViewReactor(networkService: networkService)
        }
    }
    
}
