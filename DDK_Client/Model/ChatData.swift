//
//  ChatData.swift
//  DDK_Client
//
//  Created by iOS Developer on 2022/08/17.
//

import Foundation

struct ChatData: Codable {
    var name: String
    var message: String
    
    init(
        name: String,
        message: String
    ) {
        self.name = name
        self.message = message
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let name = try? values.decode(
            String.self,
            forKey: .name
        )
        let message = try? values.decode(
            String.self,
            forKey: .message
        )
        self.name = name ?? ""
        self.message = message ?? ""
    }
    
    func jsonString() -> String {
        guard let jsonData = try? JSONEncoder().encode(self)
        else {
            return ""
        }
        return String(
            data: jsonData,
            encoding: .utf8
        ) ?? ""
    }
    
}
