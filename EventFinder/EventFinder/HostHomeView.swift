//
//  HostHomeView.swift
//  EventFinder
//
//  Created by Akhil Gudipaty on 4/30/22.
//

import SwiftUI

struct HostHomeView: View {
    @ObservedObject var manager : EventManager
    @State var user: User = User.standard_user
    @State var inProgress: Bool = true
    var body: some View {
        TabView{
            HostFirstTabView(manager: manager)
                .tabItem {
                    Image("map-fill")
                }
            CreateEventView(manager: manager)
                .tabItem{
                    Image("calendar-event-fill")
                }
            InProgressView(secretCode: "4026", eventInProgress: inProgress)
                .tabItem{
                    Image("info-circle-fill")
                }
            UserDetailsView(manager: manager, user: user)
                .tabItem{
                    Image("person-circle")
                }
            }
    }
}

struct HostHomeView_Previews: PreviewProvider {
    static var previews: some View {
        HostHomeView(manager: EventManager())
    }
}
