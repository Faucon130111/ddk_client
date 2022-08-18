//
//  Util.swift
//  DDK_Client
//
//  Created by iOS Developer on 2022/08/18.
//

import Foundation

func debug(_ message: String) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    let dateString = dateFormatter.string(from: Date())
    print("\(dateString): ### \(message)")
}
