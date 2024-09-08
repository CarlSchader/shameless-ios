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

struct ContentView: View {
    private let dateformat = DateFormatter()
    private var initialFetch = false

    @State private var logs: Array<Log> = []
    @State private var input: String = ""
    
    
    private func onEnter() {
        if let payload = self.input.data(using: .utf8) {
            let newLog = Log(
                time: Int64(Date().timeIntervalSince1970 * 1_000_000),
                payload: payload
            )
            Task {
                do {
                    try await postLogs(logs: [newLog])
                    self.logs.append(newLog)
                } catch let e {
                    debugPrint(e)
                }
            }
        }
        
        self.input = "";
    }
    
    var body: some View {
        VStack {
            List(self.logs) { log in
                HStack {
                    Text(dateformat.string(from: Date(timeIntervalSince1970: Double(log.time / 1_000_000))))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(log.payloadString())
                }
            }
            .listRowSpacing(5.0)
            .scrollContentBackground(.hidden)
            
            HStack {
                Text(">");
                TextField("jogged 2 miles, finished assignment, ...", text: self.$input)
                    .onSubmit(self.onEnter)
                    .defersSystemGestures(on: .vertical);
            }
            Divider();
        }
        .padding()
        .onTapGesture { // close keyboard on tapout
            UIApplication.shared.endEditing()
        }
        .task {
            self.logs = mergeLogLists(logs1: self.logs, logs2: await fetchLogs())
        }
    }
    
    init() {
        self.dateformat.dateFormat = "YYYY-HH:mm";
    }
}

#Preview {
    ContentView()
}
