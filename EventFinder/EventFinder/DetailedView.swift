//
//  DetailedView.swift
//  EventFinder
//
//  Created by Akhil Gudipaty on 4/29/22.
//

import SwiftUI

struct DetailedView: View {
    @ObservedObject var manager : EventManager
    @State var event: Event
    init(manager: EventManager, event: Event){
        self.manager = manager
        self.event = event
        self.manager.retrieveUserData(name: event.host_username)
    }
    var body: some View {
//        NavigationView{
            VStack{
                Image(event.event_image)
                    .resizable()
                    .frame(width: 300, height: 300, alignment: .center)
                    .cornerRadius(25)
                Text(event.name)
                    .bold()
                    .font(Font.system(size: 30))
                NavigationLink(destination: HostDetailedView(host: self.manager.host)){
                Text(event.host_username)
                    .bold()
                    .font(Font.system(size: 25))
                }
                HStack{
                    Text("Address")
                        .bold()
                        .font(Font.system(size: 25))
                    Text(event.address)
                        .font(Font.system(size: 25))
                }
                .padding()
                HStack{
                    Text(event.date)
                        .font(Font.system(size: 25))
                    Text(event.time)
                        .font(Font.system(size: 25))
                }
                .padding()
                Text(event.description)
                    .font(Font.system(size: 25))
                    .padding()
                    .multilineTextAlignment(.center)
                Text("Live Statistics")
                    .bold()
                    .font(Font.system(size: 25))
                HStack{
                    Text("Current rating:")
                        .bold()
                        .font(Font.system(size: 25))
                    Text(String(event.rating))
                        .font(Font.system(size: 25))
                    
                }
                HStack{
                    Text("Current population:")
                        .bold()
                        .font(Font.system(size: 25))
                    Text(String(event.population))
                        .font(Font.system(size: 25))
                }
                NavigationLink(destination: QRview(manager: manager, event: event)){
                ButtonView(buttonText: "Get Pass")
                }

            }
            
        }

    }




struct DetailedView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedView(manager: EventManager(), event: Event.standard)
    }
}
