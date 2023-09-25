//
//  UserSelectedColor.swift
//  TCACalc
//
//  Created by Daniel Lyons on 9/24/23.
//

import SwiftUI

public extension EnvironmentValues {
  var userSelectedColor: Color {
    get { self[UserSelectedColorEnvironmentKey.self] }
    set { self[UserSelectedColorEnvironmentKey.self] = newValue }
  }
}

public struct UserSelectedColorEnvironmentKey: EnvironmentKey {
  public static let defaultValue: Color = .green
}
