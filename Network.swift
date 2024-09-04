//
//  Network.swift
//  shameless-ios
//
//  Created by Carl Schader on 7/24/24.
//

import Foundation

let API_HOST = "http://192.168.86.240:8000"

//private func fetchLogs() {
//    let url = URL(string: API_HOST)!
//    var newLogs: [Log] = []
//
//    let task = URLSession.shared.dataTask(with: url) { data, response, error in
//        if let error = error {
//            debugPrint(error.localizedDescription)
//        }
//        if let data = data {
//            do {
//                newLogs = try JSONDecoder().decode(Array<Log>.self, from: data)
//                self.logs = newLogs
//            } catch {
//                debugPrint(error.localizedDescription)
//            }
//        }
//    }
//    task.resume()
//}
//
//private func postLog(log: Log, onSuccess: () -> () = {}) {
//    let url = URL(string: API_HOST)!
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    
//    do {
//       let jsonData = try JSONEncoder().encode(log)
//       request.httpBody = jsonData
//    } catch let error {
//        debugPrint(error.localizedDescription)
//    }
//    
//    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//        if let error = error {
//            debugPrint(error.localizedDescription)
//        }
//    }
//    task.resume()
//    onSuccess()
//}
