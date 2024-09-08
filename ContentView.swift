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
    private let dateformat = DateFormatter();

    @State private var logs: Array<Log> = []
    @State private var input: String = ""
    
    
    private func onEnter() {
        if let payload = self.input.data(using: .utf8) {
            let newLog = Log(
                time: Int64(Date().timeIntervalSince1970),
                payload: payload
            )
            
            self.logs.append(newLog);
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
            self.logs = await fetchLogs(from: 0);
            print(self.logs)
        }
    }
    
    init() {
        self.dateformat.dateFormat = "YYYY-HH:mm";
    }
}

#Preview {
    ContentView()
}
