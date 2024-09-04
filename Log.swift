//
//  Log.swift
//  shameless-ios
//
//  Created by Carl Schader on 7/24/24.
//

import Foundation

enum LogType: String {
    case userMessage = "user-message"
}

struct UserMessage: Codable {
    let message: String
}

struct LocationPayload: Codable {
    
}

enum LogPayload: Codable {
    case userMessage (UserMessage)
    case unknown (Data)
}

struct Log: Identifiable, Codable {
    let id: UUID
    let timestamp: Double
    let payload: LogPayload
    let type: String?
    
    func payloadString() -> String {
        switch self.payload {
        case .unknown(let data):
            return String(data: data, encoding: .ascii) ?? "";
        case .userMessage(let userMessage):
            return userMessage.message;
        }
    }
}
