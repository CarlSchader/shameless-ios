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
    
    @State private var errorMessage: String? = nil
    @State private var logs: Array<Log> = []
    @State private var input: String = ""
    
    
    private func onEnter() {
        if let payload = self.input.data(using: .utf8) {
            let newLog = Log(
                time: Int64(Date().timeIntervalSince1970 * 1_000_000),
                payload: payload,
                tag: "utf-8"
            )
            Task {
                do {
                    try await postLogs(logs: [newLog])
                    self.logs.append(newLog)
                } catch let error {
                    debugPrint(error)
                    self.errorMessage = error.localizedDescription
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
        .alert(isPresented: .constant(self.errorMessage != nil)) {
            Alert(title: Text("Error"), message: Text(errorMessage!.debugDescription), dismissButton: .default(Text("Ok")) {
                self.errorMessage = nil
            })
        }
        .task {
            do {
                try await runGrpcClient()
                let fetchedLogs = try await fetchLogs()
                self.logs = fetchedLogs
            } catch let error {
                self.errorMessage = error.localizedDescription
            }
//            let locationLogs = getLocationLogs()
//            self.logs = mergeLogLists(logs1: locationLogs, logs2: fetchedLogs)
//            do { try await postLogs(logs: locationLogs) } catch { print(error) }
        }
    }
    
    init() {
        self.dateformat.dateFormat = "MMM d, h:mm a";
//        getLocationAuthorization(delegate: self)
    }
}

#Preview {
    ContentView()
}
