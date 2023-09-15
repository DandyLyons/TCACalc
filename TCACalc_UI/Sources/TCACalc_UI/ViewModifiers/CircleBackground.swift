//
//  File.swift
//  
//
//  Created by Daniel Lyons on 7/14/23.
//

import Foundation
import SwiftUI

public struct CircleBackground: ViewModifier {
  public let foreground: Color
  public let foregroundBordered: Bool
  public let background: Color
  public let backgroundBordered: Bool
  public let inverted: Bool = false
  
  public init(
    foreground: Color,
    foregroundBordered: Bool = false,
    background: Color,
    backgroundBordered: Bool = false
  ) {
    self.foreground = foreground
    self.foregroundBordered = foregroundBordered
    self.background = background
    self.backgroundBordered = backgroundBordered
  }
  
  @Environment(\.colorScheme) var colorScheme
  
  var _foreground: Color { inverted ? background : foreground }
  var _background: Color { inverted ? foreground : background }
  
  public func body(content: Content) -> some View {
    ZStack {
      Circle()
        .foregroundColor(self._background)
      
      content
        .foregroundColor(self._foreground)
    }
  }
}

#Preview("CircleBackground modifier") {
  Button("Button") {}
    .modifier(CircleBackground(foreground: .white, background: .black))
}


