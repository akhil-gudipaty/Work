//
//  RegisterView.swift
//  EventFinder
//
//  Created by Akhil Gudipaty on 4/30/22.
//te

import SwiftUI

struct RegisterView: View {
    @ObservedObject var manager = EventManager()
    @State var name: String = ""
    @State var username : String = ""
    @State var password : String = ""
    @State var repass : String = ""
    var body: some View {
        VStack{
            Text("Register:")
                .bold()
                .font(Font.system(size: 30))
            TextField("name", text: $name)
                .padding()
                .background(Color.gray)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            TextField("Username", text: $username)
                .padding()
                .background(Color.gray)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            SecureField("Re-Enter Password", text: $password)
                .padding()
                .background(Color.gray)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            Button {
                let user = User(id: "", name: name, host: false, username: username, password: password, profile_pic: "standard", ratings: 0, numEvents: 0)
                manager.registerUser(user: user)
                name = ""
                username = ""
                password = ""
                repass = ""
                
            } label: {
                LogInButton(buttonText: "Register")
            }

            }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
