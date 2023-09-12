//
//  File.swift
//  
//
//  Created by Daniel Lyons on 7/14/23.
//

import Foundation
import SwiftUI

// Our custom view modifier to track rotation and
// call our action
public struct DeviceRotationViewModifier: ViewModifier {
  public let action: (UIDeviceOrientation) -> Void
  
  public func body(content: Content) -> some View {
    content
      .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
        action(UIDevice.current.orientation)
      }
  }
}

// A View wrapper to make the modifier easier to use
extension View {
  public func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
    self.modifier(DeviceRotationViewModifier(action: action))
  }
}
