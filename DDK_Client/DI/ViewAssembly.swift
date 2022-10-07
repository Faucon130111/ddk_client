//
//  ViewAssembly.swift
//  DDK_Client
//
//  Created by 박본혁 on 2022/09/27.
//

import Swinject

class ViewAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(LoginView.self) { _ in
            return LoginView()
        }
        
        container.register(SignUpView.self) { _ in
            return SignUpView()
        }
    }
    
}
