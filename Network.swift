//
//  Network.swift
//  shameless-ios
//
//  Created by Carl Schader on 7/24/24.
//

import Foundation
import GRPCCore
import GRPCHTTP2Transport
import AsyncDNSResolver

// prod
let API_HOST = "https://server-689132874253.us-west1.run.app"
let GRPC_API_HOST = "server-grpc-689132874253.us-west1.run.app"
let GRPC_API_PORT = 443
let TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImtpZCI6IjAwMDEiLCJpc3MiOiJCYXNoIEpXVCBHZW5lcmF0b3IiLCJpYXQiOjE3Mjc2MTg3MDUsImV4cCI6MTcyODQ4MjcwNX0.eyJzdWIiOiJ0ZXN0LXVzZXIiLCJOYW1lIjoidGVzdHkgbWN0ZXN0ZXIifQ.5Y8Q4RwLmH5surenMogqpFU20U03XSKK-blAYXfpiLE"

// CO copmuter
//let API_HOST = "http://192.168.31.161"
//let GRPC_API_HOST = "carlschader.com"
//let GRPC_API_PORT = 8080
//let TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImtpZCI6IjAwMDEiLCJpc3MiOiJCYXNoIEpXVCBHZW5lcmF0b3IiLCJpYXQiOjE3Mjc2MTg2NDMsImV4cCI6MTcyODQ4MjY0M30.eyJzdWIiOiJ0ZXN0LXVzZXIiLCJOYW1lIjoidGVzdHkgbWN0ZXN0ZXIifQ.0Y1D4YS2vJ89XZA5xfbUnWM_2Sm18cXayrgzMMSQ8Q8"

// local
//let API_HOST = "http://192.168.31.161:8000"
//let GRPC_API_HOST = "192.168.50.146"
//let GRPC_API_PORT = 8000
//let TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImtpZCI6IjAwMDEiLCJpc3MiOiJCYXNoIEpXVCBHZW5lcmF0b3IiLCJpYXQiOjE3Mjc0ODY3OTUsImV4cCI6MTcyODM1MDc5NX0.eyJzdWIiOiJ0ZXN0LXVzZXIiLCJOYW1lIjoidGVzdHkgbWN0ZXN0ZXIifQ.oQ1pEMetQ7HwN5F_NYV80ORNp6sSfQzD2tTlvD57Z6A"

@available(iOS 18.0, *)
var shamelessClient: Shameless_ShamelessServiceClient? = nil


func runGrpcClient() async throws {
    var ipv4HostName = GRPC_API_HOST
    let dnsRegex = /[0-9]?[0-9]?[0-9]\.[0-9]?[0-9]?[0-9]\.[0-9]?[0-9]?[0-9]\.[0-9]?[0-9]?[0-9]/
    
    if try dnsRegex.wholeMatch(in: GRPC_API_HOST) == nil {
        debugPrint("host name not ipv4, attempting dns resolution")
        let resolver = try AsyncDNSResolver()
        let records = try await resolver.queryA(name: GRPC_API_HOST)
        
        
        if records.count == 0 {
            throw MessageError.messageError("no a records found for host: " + GRPC_API_HOST)
        }
        
        for record in records {
            debugPrint(record)
        }
        let record = records[0]
        ipv4HostName = record.address.address
    }
    debugPrint("ipv4: " + ipv4HostName)
    
    if #available(iOS 18.0, *) {
        let grpcClient = try GRPCClient(
            transport: .http2NIOPosix(
                target: .ipv4(host: ipv4HostName, port: GRPC_API_PORT),
                config: .defaults(transportSecurity: .plaintext)
            )
        )
        
        Task {
            try await grpcClient.run()
        }
    
        shamelessClient = Shameless_ShamelessServiceClient(wrapping: grpcClient)
    } else {
        throw MessageError.messageError("ios version must be 18.0^ to use grpc")
    }
}

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
        )
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

func fetchLogs(from: Int64?=nil) async throws -> [Log] {
    var logs: [Log] = []
    let from: Int64 = from ?? (Int64(Date().timeIntervalSince1970) * 1_000_000 - DAY_IN_MICROSECONDS)
    if #available(iOS 18.0, *) {
        if shamelessClient != nil {
            print("fetching logs")
            var metadata = Metadata()
            metadata.addString("Bearer " + TOKEN, forKey: "authorization")
            let res = try await shamelessClient!.getLogs(Shameless_GetLogsRequest(), metadata: metadata)
            for grpc_log in res.logs {
                logs.append(Log(
                    time: grpc_log.time,
                    payload: grpc_log.payload,
                    tag: grpc_log.tag
                ))
            }
            return logs
        }
    }
    
    let urlString = API_HOST + "/api/v1/logs?from=\(from)"
    
    guard let url = URL(string: urlString) else {
        debugPrint("couldn't create url object from: \(urlString)")
        return []
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET";
    request.setValue("Bearer " + TOKEN, forHTTPHeaderField: "AUTHORIZATION")
    
    let (data, response) = try await URLSession.shared.data(for: request)
    if let response = response as? HTTPURLResponse {
        if response.statusCode < 200 || response.statusCode >= 300 {
            let message = "status code: \(response.statusCode) message:" + (String(data: data, encoding: .utf8) ?? "couldn't decode message")
            throw MessageError.messageError(message)
        } else {
            let jsonLogs = try JSONDecoder().decode([JsonLog].self, from: data)
            for jsonLog in jsonLogs {
                logs.append(jsonLog.toLog())
            }
        }
    }
    return logs
}

func postLogs(logs: [Log]) async throws {
    let urlString = API_HOST + "/api/v1/logs";
    
    guard let url = URL(string: urlString) else {
        throw MessageError.messageError("couldn't create url object from: \(urlString)")
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("Bearer " + TOKEN, forHTTPHeaderField: "AUTHORIZATION")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
        let body = try JSONEncoder().encode(logsToJsonLogs(logs: logs))
        request.httpBody = body
    } catch let error {
        throw error
    }
    
    do {
        let (data, response) = try await URLSession.shared.data(for: request)
        if let response = response as? HTTPURLResponse {
            if response.statusCode < 200 || response.statusCode >= 300 {
                let message = "status code: \(response.statusCode) message:" + (String(data: data, encoding: .utf8) ?? "couldn't decode message")
                throw MessageError.messageError(message)
            }
        }
    } catch let error {
        throw error
    }
}
