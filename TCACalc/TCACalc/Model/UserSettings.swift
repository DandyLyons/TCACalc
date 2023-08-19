//
//  UserSettings.swift
//  TCACalc
//
//  Created by Daniel Lyons on 8/18/23.
//

import Foundation
import Dependencies
import DependenciesAdditions
import SwiftUI

struct UserSettings: Equatable, Codable {
  var isDebugModeOn: Bool
  var colorSchemeMode: ColorSchemeMode
  var accentColor: Color
  
  
  /// The In-Memory representation for the current User Settings
  /// - Parameters:
  ///   - isDebugModeOn: use nil if you'd like to derive isDebugModeOn from
  ///   - colorSchemeMode: use nil if you'd like to derive ColorSchemeMode from UserDefaults
  init(isDebugModeOn: Bool? = nil, colorSchemeMode: ColorSchemeMode? = nil, accentColor: Color = .green) {
    self.isDebugModeOn = isDebugModeOn ?? Self.getIsDebugModeOnFromUserDefaults()
    self.colorSchemeMode = colorSchemeMode ?? ColorSchemeMode.getFromUserDefaults()
    self.accentColor = accentColor
  }
  
  /// reads isDebugModeOn from UserDefaults
  /// if no value exists, then initializes the value to true and saves to UserDefaults
  static func getIsDebugModeOnFromUserDefaults() -> Bool {
    @Dependency(\.userDefaults) var userDefaults
    
    if let isDebugModeOn = userDefaults.bool(forKey: UserDefaults.key_isDebugModeOn) {
      return isDebugModeOn
    } else {
      let isDebugModeOn = false
      userDefaults.set(isDebugModeOn, forKey: UserDefaults.key_isDebugModeOn)
      return isDebugModeOn
    }
  }
}

// MARK: UserDefaults Keys
extension UserDefaults {
  static let key_isDebugModeOn = "IS_DEBUG_MODE_ON"
}
