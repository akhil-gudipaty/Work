//
//  ButtonView.swift
//  EventFinder
//
//  Created by Akhil Gudipaty on 4/29/22.
//

import SwiftUI

struct ButtonView: View {
    var buttonText: String
    var body: some View {
            Text(buttonText)
                .bold()
                .font(Font.system(size: 20))
                .padding()
                .background(Capsule()
                                .strokeBorder(Color.blue, lineWidth: 150)
                                .background(Capsule().fill(Color.blue)))
                .foregroundColor(.white)
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(buttonText: "RSVP")
    }
}
