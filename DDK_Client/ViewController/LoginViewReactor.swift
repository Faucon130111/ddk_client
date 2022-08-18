//
//  LoginViewReactor.swift
//  DDK_Client
//
//  Created by iOS Developer on 2022/08/12.
//

import ReactorKit
import RxSwift
import SocketIO

class LoginViewReactor: Reactor {
    
    enum Action {
        case enterButtonTap(String)
    }
    
    enum Mutation {
        case setName(String)
        case socketConnect(Bool)
        case setLoading(Bool)
    }
    
    struct State {
        var name: String = ""
        var isConnected: Bool?
        var isLoading: Bool = false
    }
    
    var initialState: State = State()
    private var socketService: SocketService
    
    init(socketService: SocketService) {
        self.socketService = socketService
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        debug("action: \(action)")
        
        switch action {
        case let .enterButtonTap(name):
            let socketConnect = self.socketService.connect()
                .debug("### socket_connect", trimOutput: true)
                .map { Mutation.socketConnect($0) }
            return .concat(
                .just(.setLoading(true)),
                .just(.setName(name)),
                socketConnect,
                .just(.setLoading(false))
            )
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        debug("mutation: \(mutation)")
        
        var newState = state
        newState.isConnected = nil
        
        switch mutation {
        case let .setName(name):
            newState.name = name
            return newState
            
        case let .socketConnect(isConnected):
            newState.isConnected = isConnected
            return newState
            
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
            return newState
            
        }
    }
    
    func makeChatViewReactor() -> ChatViewReactor {
        return ChatViewReactor(
            name: self.currentState.name,
            socketService: self.socketService
        )
    }
    
}
