//
//  CreateEventView.swift
//  EventFinder
//
//  Created by Akhil Gudipaty on 4/30/22.
//

import SwiftUI

struct CreateEventView: View {
    @State var manager: EventManager
    @State var nameEvent: String = ""
    @State var date: String = ""
    @State var time: String = ""
    @State var description: String = ""
    @State var address: String = ""
    @State var rating: Int = 0
    var body: some View {
        VStack{
        TextField("Name of Event", text: $nameEvent)
            .padding()
            .background(Color.gray)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
        
        TextField("Date", text: $date)
                .padding()
                .background(Color.gray)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
        TextField("Time", text: $time)
                .padding()
                .background(Color.gray)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
        TextField("Address", text: $address)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
    
        TextEditor(text: $description)
                .padding()
                .background(Color.gray)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
        
            Button {
                self.manager.addEvent(event: Event(id: "0", name: nameEvent, host_username: manager.currentUser!.username, date: date, time: time, description: description, address: address, rating: 0, numRating: 0, population: 0, event_image: "standard_event"))
            } label: {
                ButtonView(buttonText: "Submit Lesson")
            }

        
        }
    }
}

struct CreateEventView_Previews: PreviewProvider {
    static var previews: some View {
        CreateEventView(manager: EventManager())
    }
}
