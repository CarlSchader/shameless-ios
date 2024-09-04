//
//  LogFile.swift
//  shameless-ios
//
//  Created by Carl Schader on 7/24/24.
//

import Foundation


let FILE_URL = FileManager.default.urls(
    for: .documentDirectory,
    in: .userDomainMask
)[0].appendingPathComponent("log.ndjson");


func writeLogs(logs: Array<Log>) {
    var writeString: String = "";
    for (_, log) in logs.enumerated() {
        do {
            let jsonData = try JSONEncoder().encode(log);
            writeString = writeString + "\n" +  String(data: jsonData, encoding: .utf8)!;
        } catch let error {
            debugPrint(error);
            return;
        }
    }
    
    if FileManager.default.fileExists(atPath: FILE_URL.path) {
        guard let data = writeString.data(using: String.Encoding.utf8) else {
            debugPrint("error unwrapping data as bytes");
            return
        }
        
        do{
            let fileHandle = try FileHandle(forWritingTo: FILE_URL);
            fileHandle.seekToEndOfFile();
            print(writeString)
            fileHandle.write(data);
            fileHandle.closeFile();
        } catch let error {
            debugPrint(error);
        }
        
    } else {
        writeString.remove(at: writeString.startIndex);
        guard let data = writeString.data(using: String.Encoding.utf8) else {
            debugPrint("error unwrapping data as bytes");
            return
        }
        do {try data.write(to: FILE_URL, options: .atomicWrite)} catch let error {debugPrint(error)}
    }
}


func readLogs(limit: Int, offset: Int = 0) -> Array<Log> {
    var logs: Array<Log> = [];
    
    if offset < 0 || limit < 0 {
        debugPrint("offset and limit must be greater than or equal to 0")
        return []
    }
    
    if !FileManager.default.fileExists(atPath: FILE_URL.path) {
        debugPrint("log file doesn't exist");
        return [];
    }
    
    let dataString: String
    do {
        dataString = try String(contentsOf: FILE_URL, encoding: String.Encoding.utf8);
    } catch let error {
        debugPrint(error);
        return [];
    }
    
    let lines = dataString.components(separatedBy: .newlines);
    let start = min(offset, lines.count - 1);
    let end = min(offset + limit, lines.count);
    for line in lines[start ..< end] {
        guard let lineData = line.data(using: String.Encoding.utf8) else {
            debugPrint("error getting buffer for line: " + line);
            continue;
        }
        do {
            let newLog = try JSONDecoder().decode(Log.self, from: lineData);
            logs.append(newLog);
        } catch {
            debugPrint("error decoding line buffer into log");
            continue;
        }
    }
    
    return logs;
}


//let READ_CHUNK_SIZE = 1024;
//
//
//func readLogsFAST(limit: Int, offset: Int = 0) -> Array<Log> {
//    var logs: Array<Log> = [];
//    
//    if !FileManager.default.fileExists(atPath: FILE_URL.path) {
//        debugPrint("log file doesn't exist");
//        return [];
//    }
//    
//    do{
//        let fileHandle = try FileHandle(forWritingTo: FILE_URL);
//        let endOffset = try fileHandle.seekToEnd();
//        
////        fileHandle.seek
//    } catch let error {
//        debugPrint(error);
//        return [];
//    }
//    return logs;
//}
