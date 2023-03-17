//
//  HostDetailedView.swift
//  EventFinder
//
//  Created by Akhil Gudipaty on 4/30/22.
//

import SwiftUI

struct HostDetailedView: View {
    @State var host: User
    var body: some View {
        VStack{
            VStack{
                Image(host.profile_pic)
                    .frame(width: 250, height: 250)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .overlay(Circle().stroke(Color.white, lineWidth: 5))
                Text(host.name)
                    .bold()
                    .font(Font.system(size: 30))
        
            }
            .padding()
            VStack{
                RatingView(rating: host.ratings)
                Text(String(host.ratings))
                    .font(Font.system(size: 25))
                
            }
            .padding()
            HStack{
                Text("Number of Events:")
                    .bold()
                    .font(Font.system(size: 25))
                Text(String(host.numEvents))
                    .font(Font.system(size: 25))
            }
            .padding()
            Button {} label: {
                ButtonView(buttonText: "Subscribe")
            }
        }
    }
}

struct HostDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        HostDetailedView(host: User.standard_host)
    }
}
