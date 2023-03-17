//
//  UserHomeView.swift
//  EventFinder
//
//  Created by Akhil Gudipaty on 4/30/22.
//

import SwiftUI

struct UserHomeView: View {
    @ObservedObject var manager : EventManager
    @State var admits = ["Event1":"2034", "Event2":"1024"]
    @State var user: User = User.standard_user
    var body: some View {
        TabView{
            EventListView(manager: manager)
                .tabItem{
                    Image("calendar-event-fill")
                }
            AdmitsView(manager: manager)
                .tabItem {
                    Image("ticket-fill")
                }
            UserDetailsView(manager: manager, user: manager.currentUser!)
                .tabItem{
                    Image("person-circle")
                }
            }
        }
}



struct UserHomeView_Previews: PreviewProvider {
    static var previews: some View {
        UserHomeView(manager: EventManager())
    }
}
