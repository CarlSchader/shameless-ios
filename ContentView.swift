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

struct Log: Identifiable, Codable {
    let id: UUID
    let text: String
    let date: Date
}

let apiHost = "http://localhost:8000"

func fetchLogs(endpointUrl: String) -> Array<Log> {
    print("fetching logs")
    var logs: Array<Log> = []
    let url = URL(string: endpointUrl)!

    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print(error.localizedDescription)
        }
        if let data = data {
            do {
                logs = try JSONDecoder().decode(Array<Log>.self, from: data)
                print(logs)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    task.resume()
    return logs
}

func postLog(log: Log, endpointUrl: String, onSuccess: () -> () = {}) {
    let url = URL(string: endpointUrl)!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
       let jsonData = try JSONEncoder().encode(log)
       request.httpBody = jsonData
    } catch let error {
       print(error.localizedDescription)
    }
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print(error.localizedDescription)
        }
    }
    task.resume()
    onSuccess()
}

struct ContentView: View {
    private let dateformat = DateFormatter()

    @State private var logs: Array<Log> = []
    @State private var input: String = ""
    
    private func onEnter() {
        let newLog = Log(id: UUID(), text: input, date: Date())
        postLog(log: newLog, endpointUrl: apiHost + "/log", onSuccess: {
            self.logs.append(newLog)
        })
        self.input = ""
        
    }
    
    var body: some View {
        VStack {
            List(logs) { log in
                HStack {
                    Text(dateformat.string(from: log.date))
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
        print("init")
        self.dateformat.dateFormat = "HH:mm"
        self.logs = fetchLogs(endpointUrl: apiHost + "/logs")
    }
}

#Preview {
    ContentView()
}
