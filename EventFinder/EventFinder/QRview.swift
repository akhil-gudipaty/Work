//
//  QRview.swift
//  EventFinder
//
//  Created by Akhil Gudipaty on 4/29/22.
//

import SwiftUI

struct QRview: View {
    @ObservedObject var manager : EventManager
    var event: Event
    var body: some View {
        ZStack{
            Color.orange
                .ignoresSafeArea()
            VStack{
                Text("One pass")
                    .bold()
                    .font(Font.system(size: 25))
                    .padding()
                QRcodeMaker(text: event.id)
                Button {
                    manager.addAdmit(event: event)
                } label: {
                    ButtonView(buttonText: "Add Pass")
                }
            }
        }
}
}

struct QRview_Previews: PreviewProvider {
    static var previews: some View {
        QRview(manager: EventManager(), event: Event.standard)
    }
}
