// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct CircleButtonStyle: ButtonStyle {
  public let foregroundIdleColor: Color
  public let backgroundIdleColor: Color
  public let foregroundPressedColor: Color
  public let backgroundPressedColor: Color
  
  public init(foregroundIdleColor: Color, backgroundIdleColor: Color, foregroundPressedColor: Color, backgroundPressedColor: Color) {
    self.foregroundIdleColor = foregroundIdleColor
    self.backgroundIdleColor = backgroundIdleColor
    self.foregroundPressedColor = foregroundPressedColor
    self.backgroundPressedColor = backgroundPressedColor
  }
  
  public init(foregroundIdleColor: Color, backgroundIdleColor: Color) {
    self.foregroundIdleColor = foregroundIdleColor
    self.backgroundIdleColor = backgroundIdleColor
    self.foregroundPressedColor = foregroundIdleColor
    self.backgroundPressedColor = backgroundIdleColor
  }
  
  public func makeBody(configuration: Configuration) -> some View {
    if configuration.isPressed {
      ZStack {
        Circle()
          .foregroundColor(self.backgroundPressedColor)

        configuration.label
          .foregroundColor(self.foregroundPressedColor)
          
          
      }
    } else {
      ZStack {
        Circle()
          .foregroundColor(self.backgroundIdleColor)
        
        configuration.label
          .foregroundColor(self.foregroundIdleColor)
          
      }
    }
  }
}

#Preview {
  Button("9") {}
    .buttonStyle(
      CircleButtonStyle(
        foregroundIdleColor: .white,
        backgroundIdleColor: .orange
      )
    )
}
