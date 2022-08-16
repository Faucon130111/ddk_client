//
//  ChatViewReactor.swift
//  DDK_Client
//
//  Created by Cresoty iOS Developer on 2022/08/16.
//

import ReactorKit
import RxSwift
import SocketIO

class ChatViewReactor: Reactor {
    
    enum Action {
        case sendButtonTap(String)
        case receiveMessage(String)
    }
    
    enum Mutation {
        case receiveMessage(String)
    }
    
    struct State {
        var newMessage: String = ""
    }
    
    var initialState: State = State()
    private var socketService: SocketService
    
    init(socketService: SocketService) {
        self.socketService = socketService
        self.socketService.receiveMessage { message in
            self.action.onNext(.receiveMessage(message))
        }
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .sendButtonTap(message):
            self.socketService.sendMessage(message)
            return .empty()
            
        case let .receiveMessage(message):
            return .just(.receiveMessage(message))
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = State()
        
        switch mutation {
        case let .receiveMessage(message):
            newState.newMessage = message
            return newState
            
        }
    }
    
}
