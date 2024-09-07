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

    @State private var logs: Array<Log>
    @State private var input: String
    
    
    private func onEnter() {
        if let payload = self.input.data(using: .utf8) {
            let newLog = Log(
                timestamp: Double(Date().timeIntervalSince1970),
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
                    Text(dateformat.string(from: Date(timeIntervalSince1970: log.timestamp)))
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
    }
    
    init() {
        self.dateformat.dateFormat = "HH:mm";
        
        _logs = State(initialValue: []);
        _input = State(initialValue: "");
    }
}

#Preview {
    ContentView()
}
