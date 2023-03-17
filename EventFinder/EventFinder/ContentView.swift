//
//  ContentView.swift
//  EventFinder
//
//  Created by Akhil Gudipaty on 4/27/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var manager = EventManager()
    var body: some View {
        if !manager.auth{
            LogInView(manager: manager)
        }
        else{
            if !manager.currentUser!.host{
                UserHomeView(manager: manager)
            }
            else{
                HostHomeView(manager: manager)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
