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
  public let background: Color
  
  public func body(content: Content) -> some View {
    ZStack {
      Circle()
        .foregroundColor(self.background)
      
      content
        .foregroundColor(self.foreground)
    }
  }
}
