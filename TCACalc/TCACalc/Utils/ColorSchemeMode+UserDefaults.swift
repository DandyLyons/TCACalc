//
//  ColorSchemeMode+UserDefaults.swift
//  TCACalc
//
//  Created by Daniel Lyons on 9/14/23.
//

import Foundation
import Dependencies
import DependenciesAdditions
import PlusNightMode

// MARK: UserDefaults
public extension UserDefaults {
  static let key_colorSchemeMode = "COLOR_SCHEME_MODE"
}

extension ColorSchemeMode {
  /// retrieves the ColorSchemeMode from UserDefaults
  /// If there is no ColorSchemeMode value, then sets it to `.auto`, saves it to
  /// UserDefaults and then returns that value
  /// - Returns: The UserDefaults value of ColorSchemeMode, (`.auto` if there is none).
  public static func getFromUserDefaults() -> Self {
    @Dependency(\.userDefaults) var userDefaults
    @Dependency(\.decode) var decode
    if let data = userDefaults.data(forKey: UserDefaults.key_colorSchemeMode),
       let ud_colorSchemeMode = try? decode(ColorSchemeMode.self, from: data) {
      return ud_colorSchemeMode
    } else {
      @Dependency(\.encode) var encode
      let colorSchemeMode: ColorSchemeMode = .auto
      let data: Data? = try? encode(colorSchemeMode)
      userDefaults.set(data, forKey: UserDefaults.key_colorSchemeMode)
      return colorSchemeMode
    }
  }
}
