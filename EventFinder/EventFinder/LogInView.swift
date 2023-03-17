//
//  LogInView.swift
//  EventFinder
//
//  Created by Akhil Gudipaty on 4/30/22.
//

import SwiftUI

struct LogInView: View {
    @ObservedObject var manager : EventManager
    @State var username = ""
    @State var password = ""
    var body: some View {
        NavigationView{
        VStack{
            Text("EventFinder")
                .bold()
                .font(Font.system(size: 30))
            
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
            Button(action: {
                manager.authenticate(username: username, password: password)
            }) {
                LogInButton(buttonText: "Login")
            }
            NavigationLink(destination: RegisterView()){
                Text("Don't have an account? Sign up.")
            }
            
            
            
        }
    }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView(manager: EventManager())
    }
}
