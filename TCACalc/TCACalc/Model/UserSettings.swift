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
import PlusNightMode

struct UserSettings: Equatable, Codable {
  var isDebugModeOn: Bool
  var colorSchemeMode: ColorSchemeMode
  var accentColor: Color
  
  
  /// The In-Memory representation for the current User Settings
  /// - Parameters:
  ///   - isDebugModeOn: use nil if you'd like to derive isDebugModeOn from
  ///   - colorSchemeMode: use nil if you'd like to derive ColorSchemeMode from UserDefaults
  init(
    isDebugModeOn: Bool? = nil,
    colorSchemeMode: ColorSchemeMode? = nil,
    accentColor: Color? = .green
  ) {
    @Dependency(\.userSettings.load) var loadUserSettings
    
    do {
//      self = try loadUserSettings()
      self.isDebugModeOn = isDebugModeOn ?? true
      self.colorSchemeMode = colorSchemeMode ?? .auto
      self.accentColor = accentColor ?? .green
    } catch {
      @Dependency(\.logger) var logger
      logger.critical("UserSettings failed to load.")
      self = .init()
    }
    self.isDebugModeOn = isDebugModeOn ?? self.isDebugModeOn
    self.colorSchemeMode = colorSchemeMode ?? self.colorSchemeMode
    self.accentColor = accentColor ?? self.accentColor
    
//    self.isDebugModeOn = true
//    self.colorSchemeMode = .auto
//    self.accentColor = .green
    
  }
  
  /// reads accent color from UserDefaults
  /// if no value exists, then initializes the value to .green and saves to UserDefaults
//  static func getAccentColorFromUserDefaults() -> Color {
//    @Dependency(\.userDefaults) var userDefaults
//    @Dependency(\.decode) var decode
//    @Dependency(\.encode) var encode
//    
//    if let data = userDefaults.data(forKey: UserDefaults.key_userSelectedAccentColor),
//       let accentColor = try? decode(Color.self, from: data) {
//      return accentColor
//    } else {
//      let accentColor = Color.green
//      let data = try! encode(accentColor)
//      userDefaults.set(data, forKey: UserDefaults.key_userSelectedAccentColor)
//      return accentColor
//    }
//  }
  
  /// reads isDebugModeOn from UserDefaults
  /// if no value exists, then initializes the value to true and saves to UserDefaults
//  static func getIsDebugModeOnFromUserDefaults() -> Bool {
//    @Dependency(\.userDefaults) var userDefaults
//    
//    if let isDebugModeOn = userDefaults.bool(forKey: UserDefaults.key_isDebugModeOn) {
//      return isDebugModeOn
//    } else {
//      let isDebugModeOn = false
//      userDefaults.set(isDebugModeOn, forKey: UserDefaults.key_isDebugModeOn)
//      return isDebugModeOn
//    }
//  }
}

// MARK: Statics
extension UserSettings {
  static let debugging = Self(
    isDebugModeOn: true
  )
  
  static let nightMode = Self(
    colorSchemeMode: .night
  )

}
    
    
// MARK: UserDefaults Keys
//extension UserDefaults {
//  static let key_isDebugModeOn = "IS_DEBUG_MODE_ON"
//  static let key_userSelectedAccentColor = "USER_SELECTED_ACCENT_COLOR"
//  static let key_userSettings = "USER_SETTINGS"
//}

