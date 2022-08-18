//
//  ServiceAssembly.swift
//  DDK_Client
//
//  Created by iOS Developer on 2022/08/18.
//

import Swinject

class ServiceAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(SocketService.self) { _ in
            let url = URL(string: Consts.socketServerURL.rawValue)!
            return SocketService(url: url)
        }
        .inObjectScope(.container)
    }
    
}
