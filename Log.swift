//
//  Log.swift
//  shameless-ios
//
//  Created by Carl Schader on 7/24/24.
//

import Foundation

struct Log: Identifiable {
    let id = UUID()
    let time: Int64
    let payload: Data
    
    func payloadString() -> String {
        if let dataString = String(data: self.payload, encoding: .utf8) {
            return dataString;
        } else {
            return "UTF8 ENCODING ERROR";
        }
    }
}
