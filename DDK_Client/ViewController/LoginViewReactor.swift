//
//  LoginViewReactor.swift
//  DDK_Client
//
//  Created by Cresoty iOS Developer on 2022/08/12.
//

import ReactorKit
import RxSwift
import SocketIO

class LoginViewReactor: Reactor {
    
    enum Action {
        case enterButtonTap
    }
    
    enum Mutation {
        case socketConnect(Bool)
        case setLoading(Bool)
    }
    
    struct State {
        var isConnected: Bool?
        var isLoading: Bool = false
    }
    
    var initialState: State = State()
    private var socketService: SocketService
    
    init(socketService: SocketService) {
        self.socketService = socketService
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .enterButtonTap:
            let socketConnect = self.socketService.connect()
                .map { Mutation.socketConnect($0) }
            return .concat(
                .just(.setLoading(true)),
                socketConnect,
                .just(.setLoading(false))
            )
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        newState.isConnected = nil
        
        switch mutation {
        case let .socketConnect(isConnected):
            newState.isConnected = isConnected
            return newState
            
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
            return newState
            
        }
    }
    
    func makeChatViewReactor() -> ChatViewReactor {
        return ChatViewReactor(socketService: self.socketService)
    }
    
}
