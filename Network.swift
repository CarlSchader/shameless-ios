//
//  Network.swift
//  shameless-ios
//
//  Created by Carl Schader on 7/24/24.
//

import Foundation

//let API_HOST = "https://server-689132874253.us-west1.run.app"
//let TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImtpZCI6IjAwMDEiLCJpc3MiOiJCYXNoIEpXVCBHZW5lcmF0b3IiLCJpYXQiOjE3MjcwNTQwMDIsImV4cCI6MTcyNzkxODAwMn0.eyJzdWIiOiJ0ZXN0LXVzZXIiLCJOYW1lIjoidGVzdHkgbWN0ZXN0ZXIifQ.J6EsyR6s7j8V2OFrVE6Yk8j4zm6WnqzV95UEeMBavBk" // prod

let API_HOST = "http://192.168.8.95:8000"
let TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImtpZCI6IjAwMDEiLCJpc3MiOiJCYXNoIEpXVCBHZW5lcmF0b3IiLCJpYXQiOjE3MjcwNTg3MzEsImV4cCI6MTcyNzkyMjczMX0.eyJzdWIiOiJ0ZXN0LXVzZXIiLCJOYW1lIjoidGVzdHkgbWN0ZXN0ZXIifQ.i3aDVosl7Z5IIk5W-9O1-TjvUDf4PitIVdc71rHh4cM" // local

let DAY_IN_MICROSECONDS: Int64 = 1_000_000 * 3600 * 24

struct JsonLog: Codable {
    let time: Int64
    let payload: String // base64 encoded
    let tag: String
    
    func toLog() -> Log {
        return Log(
            time: self.time,
            payload: Data(base64Encoded: self.payload) ?? Data(),
            tag: self.tag
        );
    }
}

func logsToJsonLogs(logs: [Log]) -> [JsonLog] {
    var jsonLogs: [JsonLog] = []
    for log in logs {
        jsonLogs.append(JsonLog(
            time: log.time,
            payload: log.payload.base64EncodedString(),
            tag: log.tag
        ))
    }
    return jsonLogs
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

func postLogs(logs: [Log]) async throws {
    let urlString = API_HOST + "/api/v1/logs";
    
    guard let url = URL(string: urlString) else {
        throw MessageError.messageError("couldn't create url object from: \(urlString)")
    }
    
    var request = URLRequest(url: url);
    request.httpMethod = "POST";
    request.setValue("Bearer " + TOKEN, forHTTPHeaderField: "AUTHORIZATION");
    request.setValue("application/json", forHTTPHeaderField: "Content-Type");
    
    do {
        let body = try JSONEncoder().encode(logsToJsonLogs(logs: logs))
        request.httpBody = body
    } catch let error {
        throw error
    }
    
    do {
        let (data, response) = try await URLSession.shared.data(for: request);
        if let response = response as? HTTPURLResponse {
            if response.statusCode < 200 || response.statusCode >= 300 {
                let message = "status code: \(response.statusCode) message:" + (String(data: data, encoding: .utf8) ?? "couldn't decode message");
                throw MessageError.messageError(message)
            }
        }
    } catch let error {
        throw error
    }
}
