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
  ///   - isDebugModeOn: use nil if you would not like to override isDebugModeOn
  ///   - colorSchemeMode: use nil if you would not like to override colorSchemeMode
  ///   - accentColor: use nil if you would not like to override accentColor
  init(
    isDebugModeOn: Bool? = nil,
    colorSchemeMode: ColorSchemeMode? = nil,
    accentColor: Color? = nil
  ) {
    @Dependency(\.userSettings.load) var loadUserSettings
    @Dependency(\.logger) var logger
    
    do {
      self = try loadUserSettings()
      self.isDebugModeOn = isDebugModeOn ?? self.isDebugModeOn
      self.colorSchemeMode = colorSchemeMode ?? self.colorSchemeMode
      self.accentColor = accentColor ?? self.accentColor
    } catch {
      logger.critical("UserSettings failed to load.")
      self = .init()
    }
  }
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

