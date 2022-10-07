//
//  APIService.swift
//  DDK_Client
//
//  Created by iOS Developer on 2022/09/02.
//

import Alamofire
import Moya
import SwiftyUserDefaults

enum APIService {
    /// 아이디 중복 체크
    case isDuplicateId(id: String)
    /// 회원가입
    case signUp(
        id: String,
        pw: String,
        name: String
    )
    /// 로그인
    case login(
        id: String,
        pw: String
    )
    // Access 토큰 재발급
    case refreshAccessToken(refreshToken: String)
}


extension APIService: TargetType {
    
    var baseURL: URL {
        return URL(string: "http://192.168.7.110:3000")!
    }
    
    var path: String {
        switch self {
        case .isDuplicateId:
            return "/api/isDuplicateId"
            
        case .signUp:
            return "/api/signUp"
            
        case .login:
            return "/api/login"
            
        case .refreshAccessToken:
            return "/api/refreshAccessToken"
            
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var headers: [String : String]? {
        var headers = ["Content-Type": "application/x-www-form-urlencoded"]
        
        switch self {
        case .isDuplicateId,
                .signUp,
                .login,
                .refreshAccessToken:
            return headers
            
        default:
            // Access 토큰 헤더로 전송
            let accessToken = Defaults[\.accessToken] ?? ""
            headers.updateValue(
                "bearer \(accessToken)",
                forKey: "Authorization"
            )
            return headers
            
        }
    }
    
    var task: Task {
        var parameters: Parameters = [:]
        switch self {
        case let .isDuplicateId(id):
            parameters = ["userId": id]
            
        case let .signUp(id, pw, name):
            parameters = [
                "userId": id,
                "userPw": pw,
                "userName": name
            ]
            
        case let .login(id, pw):
            parameters = [
                "userId": id,
                "userPw": pw
            ]
            
        case let .refreshAccessToken(refreshToken):
            parameters = [
                "refreshToken": refreshToken
            ]
            
        }
        
        return .requestParameters(
            parameters: parameters,
            encoding: URLEncoding.httpBody
        )
    }
    
}
