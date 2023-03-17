//
//  QRcodeMaker.swift
//  EventFinder
//
//  Created by Akhil Gudipaty on 4/28/22.
//

import SwiftUI
import Foundation
import CoreImage.CIFilterBuiltins

struct QRcodeMaker: View {
    let context  = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    var text: String
    
    var body: some View {
        Image(uiImage: generateQRCodeImage(text))
            .interpolation(.none)
            .resizable()
            .frame(width: 300, height: 300, alignment: .center)
    }
    
    func generateQRCodeImage(_ text: String)->UIImage{
        let data = Data(text.utf8)
        filter.setValue(data, forKey: "inputMessage")
        if let qrCodeImage = filter.outputImage{
            if let qrCodeCGImage = context.createCGImage(qrCodeImage, from: qrCodeImage.extent){
                return UIImage(cgImage: qrCodeCGImage)
            }
        }
        return UIImage(systemName: "xmark") ?? UIImage()
    }
}

struct QRcodeMaker_Previews: PreviewProvider {
    static var previews: some View {
        QRcodeMaker(text: "hello")
    }
}
