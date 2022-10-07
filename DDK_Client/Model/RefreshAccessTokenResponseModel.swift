//
//  RefreshAccessTokenResponseModel.swift
//  DDK_Client
//
//  Created by 박본혁 on 2022/09/28.
//

struct RefreshAccessTokenResponseModel: Codable {
    
    var isRefreshTokenExpired: Bool
    var accessToken: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.isRefreshTokenExpired = try container.decode(
            Bool.self,
            forKey: .isRefreshTokenExpired
        )
        
        self.accessToken = try? container.decode(
            String?.self,
            forKey: .accessToken
        )
    }
    
}
