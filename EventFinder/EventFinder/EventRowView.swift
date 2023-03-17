//
//  EventRowView.swift
//  EventFinder
//
//  Created by Akhil Gudipaty on 4/30/22.
//

import SwiftUI

struct EventRowView: View {
    var imageName : String
    var eventName: String
    var body: some View {
        HStack{
            Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 60)

                    .cornerRadius(25)
            Text(eventName)
                .bold()
                .font(Font.system(size: 30))
        }
    }
}

struct EventRowView_Previews: PreviewProvider {
    static var previews: some View {
        EventRowView(imageName: Event.standard.event_image, eventName: Event.standard.name)
    }
}
