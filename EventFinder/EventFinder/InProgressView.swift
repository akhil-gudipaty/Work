//
//  nProgressView.swift
//  EventFinder
//
//  Created by Akhil Gudipaty on 4/30/22.
//

import SwiftUI

struct InProgressView: View {
    @State var secretCode: String
    @State var eventInProgress : Bool
    var body: some View {
        NavigationView{
        VStack{
            if (eventInProgress){
                Text("Event Currently in progress")
                    .bold()
                    .font(Font.system(size: 30))
                    .padding()
                NavigationLink(destination: ScannerView(value: secretCode)){
                ButtonView(buttonText: "Scan Admit Pass")
                }
            }
            else{
                Text("No Events in progress")
                    .bold()
                    .font(Font.system(size: 30))
                    .padding()
            }

        }
    }
    }
}

struct InProgressView_Previews: PreviewProvider {
    static var previews: some View {
        InProgressView(secretCode: "2304", eventInProgress: false)
    }
}
