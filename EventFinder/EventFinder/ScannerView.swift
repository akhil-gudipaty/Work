//
//  ScannerView.swift
//  EventFinder
//
//  Created by Akhil Gudipaty on 4/28/22.
//

import SwiftUI
import CodeScanner

struct ScannerView: View {
    var value : String
    @State var isPresentingScanner = false
    @State var scannerCode:String = "Scan QR to admit"
    var scannerSheet: some View{
        CodeScannerView(codeTypes: [.qr]) { result in
            if case let .success(code) = result {
                if code.string == value{
                    self.scannerCode = "Yes please admit"
                }
                else{
                    self.scannerCode = "Don't admit"
                }
                //self.scannerCode = code.string
                self.isPresentingScanner = false
            }
        }
    }
    var body: some View {
        VStack(spacing: 10){
            Text(scannerCode)
            
            Button("Scan QR code"){
                self.isPresentingScanner = true
            }
            .sheet(isPresented: $isPresentingScanner){
                self.scannerSheet
            }
        }
    }
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView(value: "2304")
    }
}
