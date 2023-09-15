// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct CircleButtonStyle: ButtonStyle {
  public let foregroundIdleColor: Color
  public let backgroundIdleColor: Color
  public let showingIdleBorder: Bool
  public let foregroundPressedColor: Color
  public let backgroundPressedColor: Color
  public let showingPressedBorder: Bool
  
  public init(
    foregroundIdleColor: Color,
    backgroundIdleColor: Color,
    showingIdleBorder: Bool = false,
    foregroundPressedColor: Color,
    backgroundPressedColor: Color,
    showingPressedBorder: Bool = false
  ) {
    self.foregroundIdleColor = foregroundIdleColor
    self.backgroundIdleColor = backgroundIdleColor
    self.showingIdleBorder = showingIdleBorder
    self.foregroundPressedColor = foregroundPressedColor
    self.backgroundPressedColor = backgroundPressedColor
    self.showingPressedBorder = showingPressedBorder
  }
  
  public init(
    foregroundIdleColor: Color,
    showingIdleBorder: Bool = false,
    backgroundIdleColor: Color,
    showingPressedBorder: Bool = false
  ) {
    self.foregroundIdleColor = foregroundIdleColor
    self.backgroundIdleColor = backgroundIdleColor
    self.showingIdleBorder = showingIdleBorder
    self.foregroundPressedColor = foregroundIdleColor
    self.backgroundPressedColor = backgroundIdleColor
    self.showingPressedBorder = showingPressedBorder
  }
  
  public func makeBody(configuration: Configuration) -> some View {
    if configuration.isPressed {
      ZStack {
        if showingPressedBorder {
          Circle()
            .foregroundColor(self.backgroundPressedColor)
            .border(self.foregroundPressedColor)
        } else {
          Circle()
            .foregroundColor(self.backgroundPressedColor)
        }

        configuration.label
          .foregroundColor(self.foregroundPressedColor)
        
          
          
      }
    } else {
      ZStack {
        if showingIdleBorder {
          Circle()
            .foregroundColor(self.backgroundIdleColor)
            .border(self.foregroundIdleColor)
        } else {
          Circle()
            .foregroundColor(self.backgroundIdleColor)
        }
        
        configuration.label
          .foregroundColor(self.foregroundIdleColor)
          
      }
    }
  }
}

#Preview("CircleButtonStyle") {
  Button("9") {}
    .buttonStyle(
      CircleButtonStyle(
        foregroundIdleColor: .white,
        backgroundIdleColor: .orange
      )
    )
}
