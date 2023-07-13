// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

struct CircleButtonStyle: ButtonStyle {
  let backgroundPressedColor: Color
  let backgroundIdleColor: Color
  let foregroundPressedColor: Color
  let foregroundIdleColor: Color
  
  func makeBody(configuration: Configuration) -> some View {
    if configuration.isPressed {
      ZStack {
        Circle()
          .foregroundColor(self.backgroundPressedColor)

        configuration.label
          .foregroundColor(self.foregroundPressedColor)
          .padding()
          
      }
    } else {
      ZStack {
        Circle()
          .foregroundColor(self.backgroundIdleColor)
        
        configuration.label
          .foregroundColor(self.foregroundIdleColor)
          .padding()
          .border(.green)
      }
    }
  }
}
extension ButtonStyle where Self == CircleButtonStyle {
  
  static func circle(
    backgroundPressedColor: Color = .secondary,
    backgroundIdleColor: Color = .secondary,
    foregroundPressedColor: Color = .primary,
    foregroundIdleColor: Color = .primary) -> CircleButtonStyle {
    return CircleButtonStyle(backgroundPressedColor: backgroundPressedColor, backgroundIdleColor: backgroundIdleColor, foregroundPressedColor: foregroundPressedColor, foregroundIdleColor: foregroundIdleColor)
  }
}

#Preview {
  Button("9") {}
    .buttonStyle(.circle(backgroundPressedColor: <#T##Color#>, backgroundIdleColor: <#T##Color#>, foregroundPressedColor: <#T##Color#>, foregroundIdleColor: <#T##Color#>))
}
