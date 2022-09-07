//
//  NetworkService.swift
//  DDK_Client
//
//  Created by iOS Developer on 2022/09/02.
//

import Alamofire
import JWTDecode
import Moya
import RxCocoa
import RxSwift
import SwiftyJSON
import SwiftyUserDefaults

protocol NetworkServiceSpec {
    func request(_ api: APIService)  -> Observable<JSON?>
}

class NetworkService: NetworkServiceSpec {
    
    private let provider = MoyaProvider<APIService>()
    private var disposeBag: DisposeBag!

    func request(_ api: APIService)  -> Observable<JSON?> {
        let requestAPI = self.observable(for: api)

        switch api {
        case .signUp,
                .login:
            return requestAPI
            
        default:
            // 만료된 Token 체크하여 재발급 후 API 요청
            return self.refreshExpiredTokens()
                .flatMap { _ in requestAPI }
        }
    }
    
    private func observable(for api: APIService) -> Observable<JSON?> {
        return self.provider.rx
            .request(api)
            .debug("### observable: \(api)", trimOutput: true)
            .retry(3)
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .map { JSON($0.data) }
            .catchAndReturn(nil)
            .asObservable()
    }
    
    private func refreshExpiredTokens() -> Observable<Void> {
        var isRefreshTokenExpired = true
        var isAccessTokenExpired = true
        
        // Refresh 토큰 만료 체크
        if let refreshToken = Defaults[\.refreshToken],
           let jwt = try? decode(jwt: refreshToken) {
            isRefreshTokenExpired = jwt.expired
        }
        
        // Access 토큰 만료 체크
        if let accessToken = Defaults[\.accessToken],
           let jwt = try? decode(jwt: accessToken) {
            isAccessTokenExpired = jwt.expired
        }
        
        if isRefreshTokenExpired {
            debug("isRefreshTokenExpired")
            // Refresh 토큰 만료 시 모두 재발급
            let loginID = Defaults[\.loginID] ?? ""
            let loginPW = Defaults[\.loginPW] ?? ""
            
            return self.observable(for: .login(
                id: loginID,
                pw: loginPW
            ))
            .map { json -> Void in
                Defaults[\.accessToken] = json?["accessToken"].string
                Defaults[\.refreshToken] = json?["refreshToken"].string
                return ()
            }
        } else if isAccessTokenExpired {
            debug("isAccessTokenExpired")
            // Access 토큰 만료 시 재발급
            let refreshToken = Defaults[\.refreshToken] ?? ""
            
            return self.observable(for: .refreshAccessToken(refreshToken: refreshToken))
                .map { json -> Void in
                    Defaults[\.accessToken] = json?["accessToken"].string
                    return ()
                }
        }
        
        // 토큰 모두 만료되지 않음
        debug("tokens all fine")
        return .just(())
    }
    
}
