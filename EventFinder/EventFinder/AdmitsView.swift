//
//  AdmitsView.swift
//  EventFinder
//
//  Created by Akhil Gudipaty on 4/30/22.
//

import SwiftUI

struct AdmitsView: View {
    @ObservedObject var manager : EventManager
    var body: some View {
        TabView {
            ForEach(manager.admits.sorted(by: >), id: \.key) {event,admit in
                VStack{
                        Text(event)
                        .font(Font.system(size: 30))
                        .bold()
                        QRcodeMaker(text: admit)
                }
                    }
                }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .background(.blue)
    }
}

struct AdmitsView_Previews: PreviewProvider {
    static var previews: some View {
        AdmitsView(manager: EventManager())
    }
}
