//
//  DIContainer.swift
//  DDK_Client
//
//  Created by iOS Developer on 2022/08/18.
//

import Swinject

class DIContainer {
    
    static let instance = DIContainer()
    
    let container: Container
    private let assembler: Assembler
    
    private init() {
        self.container = Container()
        self.assembler = Assembler(
            [
                ServiceAssembly(),
                ReactorAssembly(),
                ViewAssembly(),
                ViewControllerAssembly()
            ],
            container: self.container
        )
    }
    
}
