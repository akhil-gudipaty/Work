//
//  EventFinderApp.swift
//  EventFinder
//
//  Created by Akhil Gudipaty on 4/27/22.
//

import SwiftUI
import Firebase

@main
struct EventFinderApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
