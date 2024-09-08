//
//  Network.swift
//  shameless-ios
//
//  Created by Carl Schader on 7/24/24.
//

import Foundation

//let API_HOST = "https://server-689132874253.us-west1.run.app"
//let TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImtpZCI6IjAwMDEiLCJpc3MiOiJCYXNoIEpXVCBHZW5lcmF0b3IiLCJpYXQiOjE3MjU3MzQ3MTgsImV4cCI6MTcyNjU5ODcxOH0.eyJzdWIiOiJ0ZXN0LXVzZXIiLCJOYW1lIjoidGVzdHkgbWN0ZXN0ZXIifQ.A98uH987BDDqO1mGh67qhIBPwri6wGOjkaGixYmMJQ" // prod

let API_HOST = "http://172.20.10.2:8000"
let TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImtpZCI6IjAwMDEiLCJpc3MiOiJCYXNoIEpXVCBHZW5lcmF0b3IiLCJpYXQiOjE3MjU3MzM0MTYsImV4cCI6MTcyNjU5NzQxNn0.eyJzdWIiOiJ0ZXN0LXVzZXIiLCJOYW1lIjoidGVzdHkgbWN0ZXN0ZXIifQ.ulGnLkOLTt7WF_xQEItpS1tAwIyyQ3m01-c2m8Xdgxw" // local

let DAY_IN_MICROSECONDS: Int64 = 1_000_000 * 3600 * 24

struct JsonLog: Codable {
    let time: Int64
    let payload: String // base64 encoded
    
    func toLog() -> Log {
        return Log(
            time: self.time,
            payload: Data(base64Encoded: self.payload) ?? Data()
        );
    }
}

func fetchLogs(from: Int64?=nil) async -> [Log] {
    var logs: [Log] = [];
    let from: Int64 = from ?? (Int64(Date().timeIntervalSince1970) * 1_000_000 - DAY_IN_MICROSECONDS);
    
    let urlString = API_HOST + "/api/v1/logs?from=\(from)";
    
    guard let url = URL(string: urlString) else {
        debugPrint("couldn't create url object from: \(urlString)");
        return [];
    }
    
    var request = URLRequest(url: url);
    request.httpMethod = "GET";
    request.setValue("Bearer " + TOKEN, forHTTPHeaderField: "AUTHORIZATION");
    
    do {
        let (data, response) = try await URLSession.shared.data(for: request);
        if let response = response as? HTTPURLResponse {
            if response.statusCode < 200 || response.statusCode >= 300 {
                let message = "status code: \(response.statusCode) message:" + (String(data: data, encoding: .utf8) ?? "couldn't decode message");
                debugPrint(message);
            } else {
                do {
                    let jsonLogs = try JSONDecoder().decode([JsonLog].self, from: data)
                    for jsonLog in jsonLogs {
                        logs.append(jsonLog.toLog());
                    }
                } catch let error {
                    debugPrint(error);
                    debugPrint(data);
                }
            }
        }
    } catch {
        debugPrint(error);
    }
    
    return logs;
}

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
