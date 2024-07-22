//
//  ContentView.swift
//  shameless-ios
//
//  Created by Carl Schader on 7/20/24.
//

import SwiftUI

// add function to UIApplication to close keyboard
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct UserMessage: Codable {
    let message: String
}

struct Log: Identifiable, Codable {
    let id: UUID
    let timestamp: Double
    let type: String
    let payload: Data
}

let API_HOST = "http://192.168.86.240:8000"

struct ContentView: View {
    private let dateformat = DateFormatter()

    @State private var logs: Array<Log> = []
    @State private var input: String = ""
    
    private func fetchLogs() {
        let url = URL(string: API_HOST)!
        var newLogs: [Log] = []

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
            if let data = data {
                do {
                    newLogs = try JSONDecoder().decode(Array<Log>.self, from: data)
                    self.logs = newLogs
                } catch {
                    debugPrint(error.localizedDescription)
                }
            }
        }
        task.resume()
    }

    private func postLog(log: Log, onSuccess: () -> () = {}) {
        let url = URL(string: API_HOST)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
           let jsonData = try JSONEncoder().encode(log)
           request.httpBody = jsonData
        } catch let error {
            debugPrint(error.localizedDescription)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
        }
        task.resume()
        onSuccess()
    }
    
    private func onEnter() {
        let newLog = Log(id: UUID(), payload: input.data(using: .utf8) ?? Data(), timestamp: Double(Date().timeIntervalSince1970))
        self.postLog(log: newLog, onSuccess: {
            self.logs.append(newLog)
        })
        self.input = ""
        
    }
    
    var body: some View {
        VStack {
            List(self.$logs) { log in
                HStack {
                    Text(dateformat.string(from: Date(timeIntervalSince1970: log.timestamp)))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(log.text)
                }
            }
            .listRowSpacing(5.0)
            .scrollContentBackground(.hidden)
            
            HStack {
                Text(">")
                TextField("jogged 2 miles, finished assignment, ...", text: self.$input)
                    .onSubmit(self.onEnter)
            }
            Divider()
        }
        .padding()
        .onTapGesture { // close keyboard on tapout
            UIApplication.shared.endEditing()
        }
    }
    
    
    init() {
        self.dateformat.dateFormat = "HH:mm"
        self.fetchLogs()
    }
}

#Preview {
    ContentView()
}
