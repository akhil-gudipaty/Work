//
//  LogInButton.swift
//  EventFinder
//
//  Created by Akhil Gudipaty on 4/30/22.
//

import SwiftUI

struct LogInButton: View {
    var buttonText: String
    var body: some View {
        Text(buttonText)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.green)
            .cornerRadius(15.0)
    }
}

struct LogInButton_Previews: PreviewProvider {
    static var previews: some View {
        LogInButton(buttonText: "LogIn")
    }
}
