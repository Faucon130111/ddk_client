//
//  LoginResponseModel.swift
//  DDK_Client
//
//  Created by 박본혁 on 2022/09/28.
//

struct LoginResponseModel: Codable {
    
    var accessToken: String
    var refreshToken: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.accessToken = try container.decode(
            String.self,
            forKey: .accessToken
        )
        
        self.refreshToken = try container.decode(
            String.self,
            forKey: .refreshToken
        )
    }
    
}
