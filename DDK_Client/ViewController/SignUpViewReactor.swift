//
//  SignUpViewReactor.swift
//  DDK_Client
//
//  Created by 박본혁 on 2022/10/05.
//

import ReactorKit
import RxSwift

class SignUpViewReactor: Reactor {
    
    enum Action {
        case idValueChanged(String)
        case pwValueChanged(String, String)
        case nameValueChanged(String)
        case signUpButtonTap
    }
    
    enum Mutation {
        case setIsDuplicateId(Bool)
        case setIsDuplicateIdCheckLoading(Bool)
        case setIsPWConfirmEqual(Bool)
        case setSignUpSuccess(Bool)
        case setLoading(Bool)
        case setID(String)
        case setPW(String)
        case setName(String)
    }
    
    struct State {
        var isDuplicateId: Bool?
        var isDuplicateIdCheckLoading: Bool = false
        var isDuplicateIdLabelText: String = ""
        var isDuplicateIdLabelTextColor: UIColor = .clear
        var isPWConfirmEqual: Bool = true
        var isSignUpButtonEnabled: Bool = false
        @Pulse var isSignUpSuccess: Bool?
        var isLoading: Bool = false
        var id: String = ""
        var pw: String = ""
        var name: String = ""
    }
    
    var initialState: State = State()
    var networkService: NetworkServiceSpec
    
    init(networkService: NetworkServiceSpec) {
        self.networkService = networkService
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .idValueChanged(id):
            let requestIsDuplicateId = self.networkService
                .request(
                    .isDuplicateId(id: id),
                    type: IsDuplicateIDResponseModel.self
                )
                .map { Mutation.setIsDuplicateId($0?.isDuplicateId ?? true) }
            
            return .concat(
                .just(.setIsDuplicateIdCheckLoading(true)),
                .just(.setID(id)),
                requestIsDuplicateId,
                .just(.setIsDuplicateIdCheckLoading(false))
            )
            
        case let .pwValueChanged(pw, pwConfirm):
            let isEqual = pw == pwConfirm
            return .concat(
                .just(.setPW(isEqual ? pw : "")),
                .just(.setIsPWConfirmEqual(isEqual))
            )
            
        case let .nameValueChanged(name):
            return .just(.setName(name))
            
        case .signUpButtonTap:
            let requestSignUp = self.networkService
                .request(
                    .signUp(
                        id: self.currentState.id,
                        pw: self.currentState.pw,
                        name: self.currentState.name
                    ),
                    type: SignUpResponseModel.self
                )
                .map { Mutation.setSignUpSuccess($0?.isSignUpSuccess ?? false) }

            return .concat([
                .just(.setLoading(true)),
                requestSignUp,
                .just(.setLoading(false))
            ])
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        let isSignUpButtonEnabled = newState.id.isNotEmpty && newState.isDuplicateId == false && newState.pw.isNotEmpty && newState.name.isNotEmpty
        newState.isSignUpButtonEnabled = isSignUpButtonEnabled
        
        switch mutation {
        case let .setIsDuplicateId(isDuplicateId):
            if isDuplicateId {
                newState.id = ""
            }
            newState.isDuplicateId = isDuplicateId
            newState.isDuplicateIdLabelText = isDuplicateId ? "* 중복된 아이디 입니다." : "* 사용 가능한 아이디 입니다."
            newState.isDuplicateIdLabelTextColor = isDuplicateId ? .systemRed.withAlphaComponent(0.7) : .systemBlue.withAlphaComponent(0.7)
            return newState
            
        case let .setIsDuplicateIdCheckLoading(isLoading):
            newState.isDuplicateIdCheckLoading = isLoading
            return newState
            
        case let .setIsPWConfirmEqual(isEqual):
            newState.isPWConfirmEqual = isEqual
            return newState
            
        case let .setSignUpSuccess(isSignUpSuccess):
            newState.isSignUpSuccess = isSignUpSuccess
            return newState
            
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
            return newState
       
        case let .setID(id):
            newState.id = id
            return newState
            
        case let .setPW(pw):
            newState.pw = pw
            return newState
            
        case let .setName(name):
            newState.name = name
            return newState
            
            
        }
    }
    
}
