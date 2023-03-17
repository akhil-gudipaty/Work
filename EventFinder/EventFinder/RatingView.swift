//
//  RatingView.swift
//  EventFinder
//
//  Created by Akhil Gudipaty on 4/30/22.
//

import SwiftUI

struct RatingView: View {
    private static let MAX_RATING: Float = 5 // Defines upper limit of the rating
    private static let COLOR = Color.yellow
    let rating: Float
    private let fullCount: Int
    private let emptyCount: Int
    private let halfFullCount: Int
    init(rating: Float) {
      self.rating = rating
      fullCount = Int(rating)
      emptyCount = Int(RatingView.MAX_RATING - rating)
      halfFullCount = (Float(fullCount + emptyCount) < RatingView.MAX_RATING) ? 1 : 0
    }
    var body: some View {
        HStack {
          ForEach(0..<fullCount) { _ in
             self.fullStar
           }
           ForEach(0..<halfFullCount) { _ in
             self.halfFullStar
           }
           ForEach(0..<emptyCount) { _ in
             self.emptyStar
           }
         }
    }
    private var fullStar: some View {
      Image(systemName: "star.fill").foregroundColor(RatingView.COLOR)
    }

    private var halfFullStar: some View {
      Image(systemName: "star.lefthalf.fill").foregroundColor(RatingView.COLOR)
    }

    private var emptyStar: some View {
      Image(systemName: "star").foregroundColor(RatingView.COLOR)
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: 4)
    }
}
