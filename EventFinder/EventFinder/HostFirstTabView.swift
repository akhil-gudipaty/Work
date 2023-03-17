//
//  HostFirstTabView.swift
//  EventFinder
//
//  Created by Akhil Gudipaty on 4/30/22.
//

import SwiftUI

struct HostFirstTabView: View {
    @ObservedObject var manager : EventManager
    init(manager: EventManager){
        self.manager=manager
        self.manager.getEvents()
    }
    var body: some View {
        VStack{
        Text("Upcoming events")
            .bold()
            .font(Font.system(size: 30))
        ScrollView(.vertical) {
            VStack{
                ForEach(self.manager.hostEvents!) {i in
                        EventRowView(imageName: i.event_image, eventName: i.name)
                }
        }
        }
    }
    }
}

struct HostFirstTabView_Previews: PreviewProvider {
    static var previews: some View {
        HostFirstTabView(manager:EventManager())
    }
}
