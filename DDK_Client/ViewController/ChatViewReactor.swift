//
//  ChatViewReactor.swift
//  DDK_Client
//
//  Created by iOS Developer on 2022/08/16.
//

import ReactorKit
import RxSwift
import SocketIO

class ChatViewReactor: Reactor {
    
    enum Action {
        case sendButtonTap(String)
        case receiveChatData(ChatData)
    }
    
    enum Mutation {
        case receiveChatData(ChatData)
    }
    
    struct State {
        var newChatData: ChatData?
    }
    
    var initialState: State = State()
    private var name: String
    private var socketService: SocketService
    var sendChatDataComplete: (() -> Void)?
    
    init(
        name: String,
        socketService: SocketService
    ) {
        self.name = name
        self.socketService = socketService
        self.socketService.receiveChatData { chatData in
            self.action.onNext(.receiveChatData(chatData))
        }
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .sendButtonTap(message):
            let chatData = ChatData(
                name: self.name,
                message: message
            )
            self.socketService.sendChatData(chatData) {
                self.sendChatDataComplete?()
            }
            return .empty()

        case let .receiveChatData(chatData):
            return .just(.receiveChatData(chatData))
            
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = State()
        
        switch mutation {
        case let .receiveChatData(chatData):
            newState.newChatData = chatData
            return newState
            
        }
    }
    
}
