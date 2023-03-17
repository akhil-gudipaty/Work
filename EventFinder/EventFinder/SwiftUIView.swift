//
//  SwiftUIView.swift
//  EventFinder
//
//  Created by Akhil Gudipaty on 5/1/22.
//

import SwiftUI

struct SwiftUIView: View {
    @ObservedObject var manager = EventManager()
    var body: some View {
        VStack{
            Text("test")
            ForEach(manager.users){i in
                Text(i.name)
            }
        }

        
    }
    init(){
        manager.getData()
        manager.getEvents()
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
