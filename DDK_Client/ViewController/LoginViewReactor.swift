//
//  LoginViewReactor.swift
//  DDK_Client
//
//  Created by 박본혁 on 2022/09/27.
//

import ReactorKit
import RxSwift

class LoginViewReactor: Reactor {
    
    enum Action {
        case loginButtonTap([String])
    }
    
    enum Mutation {
        case setLoginComplete(Bool)
        case setLoading(Bool)
    }
    
    struct State {
        @Pulse var isLoginComplete: Bool?
        var isLoading: Bool = false
    }

    var initialState: State = State()
    var networkService: NetworkServiceSpec
    
    init(networkService: NetworkServiceSpec) {
        self.networkService = networkService
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .loginButtonTap(datas):
            let requestLogin = self.networkService.request(
                .login(
                    id: datas.first ?? "",
                    pw: datas.last ?? ""
                ),
                type: LoginResponseModel.self
            )
            .map { $0 != nil }
            .delay(.seconds(3), scheduler: MainScheduler.instance)
            
            return .concat(
                .just(.setLoading(true)),
                requestLogin.map(Mutation.setLoginComplete),
                .just(.setLoading(false))
            )
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setLoginComplete(isLoginComplete):
            newState.isLoginComplete = isLoginComplete
            return newState
            
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
            return newState
            
        }
    }
    
}
