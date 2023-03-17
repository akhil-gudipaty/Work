//
//  EventListView.swift
//  EventFinder
//
//  Created by Akhil Gudipaty on 4/30/22.
//

import SwiftUI

struct EventListView: View {
    @ObservedObject var manager : EventManager
    init(manager: EventManager){
        self.manager = manager
        self.manager.getEvents()
    }
    var body: some View {
        NavigationView{
        ScrollView(.vertical) {
            VStack{
                ForEach(manager.events) {i in
                    NavigationLink(destination: DetailedView(manager: manager, event: i)) {
                        EventRowView(imageName: i.event_image, eventName: i.name)
                    }
                }
        }
        }
        }

    }
}

struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        EventListView(manager: EventManager())
    }
}
