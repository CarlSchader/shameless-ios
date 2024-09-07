//
//  Network.swift
//  shameless-ios
//
//  Created by Carl Schader on 7/24/24.
//

import Foundation

let TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImtpZCI6IjAwMDEiLCJpc3MiOiJCYXNoIEpXVCBHZW5lcmF0b3IiLCJpYXQiOjE3MjU3MzQ3MTgsImV4cCI6MTcyNjU5ODcxOH0.eyJzdWIiOiJ0ZXN0LXVzZXIiLCJOYW1lIjoidGVzdHkgbWN0ZXN0ZXIifQ.A98uH987BDDqO1mGh67qhIBPwri6wGOjkaGixYmMJQ"
let API_HOST = "https://server-689132874253.us-west1.run.app/"

//private func fetchLogs() {
//    let url = URL(string: API_HOST)!
//    var newLogs: [Log] = []
//
//    let task = URLSession.shared.dataTask(with: ul) { data, response, error in
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
