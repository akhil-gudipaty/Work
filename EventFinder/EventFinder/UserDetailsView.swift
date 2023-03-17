//
//  UserDetailsView.swift
//  EventFinder
//
//  Created by Akhil Gudipaty on 4/30/22.
//

import SwiftUI

struct UserDetailsView: View {
    @ObservedObject var manager : EventManager
    @State var user: User
    var body: some View {
        VStack{
            VStack{
                Image(user.profile_pic)
                    .frame(width: 250, height: 250)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .overlay(Circle().stroke(Color.white, lineWidth: 5))
                Text(user.name)
                    .bold()
                    .font(Font.system(size: 30))
        
            }
            .padding()
            HStack{
                Text("Username:")
                    .bold()
                    .font(Font.system(size: 25))
                Text(String(user.username))
                    .font(Font.system(size: 25))
            }
            .padding()

            Text("Event Finder © 2022")
                .font(Font.system(size: 15))
                .padding()
            
            Button {
                manager.auth = false
            } label: {
                ButtonView(buttonText: "Sign Out")
            }
                .padding()
        }
    }
}

struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailsView(manager: EventManager(), user: User.standard_user)
    }
}
